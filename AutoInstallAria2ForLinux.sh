#!/bin/bash
# Linux工具包，默认apt-get
method="None"
# 环境地址
shellPath=$(pwd)

function printMintimate() {
    echo -e "\033[32m
_____________________________________________________________
    _   _
    /  /|     ,                 ,
---/| /-|----------__---_/_---------_--_-----__---_/_-----__-
  / |/  |   /    /   )  /     /    / /  )  /   )  /     /___)
_/__/___|__/____/___/__(_ ___/____/_/__/__(___(__(_ ___(___ _
         Mintimate's Blog:https://www.mintimate.cn
_____________________________________________________________
 \033[0m"
}

function judgeVersion() {
    # 创建局部变量，判断使用工具包
    local version="None"
    # 判断Linux系统版本
    source /etc/os-release
    case $ID in
    debian | ubuntu | devuan )
        version="apt-get"
        ;;
    centos | fedora | rhel)
        local yumdnf="yum"
        if test "$(echo "$VERSION_ID >= 22" | bc)" -ne 0; then
            local yumdnf="dnf"
        fi
        version=${yumdnf}
        ;;
    *)
        echo -e "\033[31m 未知Linux版本，请手动选择： \033[0m"
        echo "1:使用apt-get工具包的Linux"
        echo "2:使用yum工具包的Linux"
        echo "3:使用dnf工具包的Linux"
        echo "0或其他按键：其他工具包"
        read temp
        if [ ${temp} -eq "1" ]; then
            version="apt-get"
        elif [ ${temp} -eq "2" ]; then
            return="yum"
        elif [ ${temp} -eq "3" ]; then
            version="dnf"
        else
            version="None"
        fi
        ;;
    esac

    # 判断是否支持该脚本
    if [ ${version} == "None" ]; then
        echo -e "\033[31m 你的系统不支持该脚本 \033[0m"
        echo -e "\033[31m 请联系我： \033[0m"
        echo -e "\033[31m QQ：198330181 \033[0m"
        echo -e "\033[31m （限：求助前，有给我视频三连的粉丝用户） \033[0m"
        exit
    fi
    method=${version}
}
function judgeArchitecture(){
    echo -e "\033[31m 判断系统架构 \033[0m"
    echo -e "\033[32m 正在下载( ´▽｀) \033[0m"
    OS="$(uname -m)"
    case $OS in
    aarch64 | arm64 | arm )
        wget -qO ${shellPath}/Aria2.tar.bz2 "https://github.com/Mintimate/AutoInstallAria2/raw/main/aria2-1.35.0-linux-gnu-arm-rbpi-build1.tar.bz2"
        ;;
    x86_64 | x64 )
        wget -qO ${shellPath}/Aria2.tar.bz2 "https://github.com/Mintimate/AutoInstallAria2/raw/main/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2"
        ;;
    *)
        echo -e "\033[31m 未知Linux架构，请手动选择： \033[0m"
        echo "1:x86 32位的Linux"
        echo "2:x86 64位的Linux"
        echo "3:ARM 架构的Linux"
        echo "0或其他按键：其他工具包"
        read temp
        if [ ${temp} -eq "1" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://github.com/Mintimate/AutoInstallAria2/raw/main/aria2-1.35.0-linux-gnu-32bit-build1.tar.bz2"
        elif [ ${temp} -eq "2" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://github.com/Mintimate/AutoInstallAria2/raw/main/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2"
        elif [ ${temp} -eq "3" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://github.com/Mintimate/AutoInstallAria2/raw/main/aria2-1.35.0-linux-gnu-arm-rbpi-build1.tar.bz2"
        else
            echo -e "\033[31m 本脚本不支持其他架构 \033[0m"
            exit
        fi
        ;;
    esac
    
}

printMintimate

echo -e "\033[32m
    Aria2快速配置脚本
    作者：Mintimate
   
    使用本脚本可以一键在Linux上配置Aria2
    获取帮助：
    QQ：198330181
    （限：求助前，有给我视频三连的粉丝用户）
    
    更多教程：
    Mintimate's Blog:
    https://www.mintimate.cn
    
    Mintimate's Bilibili:
    https://space.bilibili.com/355567627
 \033[0m"

# 设置密码
echo "设置Aria2密码"
echo -e "\033[31m (用于远程Aria2认证) \033[0m"
read Aria2token

judgeVersion

# 下载Aria2源文件
echo -e "\033[32m 下载远程配置Aria2源码 \033[0m"
judgeArchitecture

echo -e "\033[32m 创建解压临时文件 \033[0m"
mkdir Aria2Temp
echo -e "\033[32m 解压Aria2文件 \033[0m"
tar -xf ${shellPath}/Aria2.tar.bz2 -C ${shellPath}/Aria2Temp

# 切换脚本目录到Aria2文件内
cd ${shellPath}/Aria2Temp/*
shellPath=$(pwd)

echo -e "\033[32m 提权Aria2 \033[0m"
chmod +x aria2c



dirAria2=${HOME}/Downloads #下载文件存储目录
if [ -d ${dirAria2} ];then
  else
  mkdir ${HOME}/Downloads
fi

# 配置自动删除日志脚本
echo -e "\033[32m 配置自动删除日志脚本 \033[0m"
wget -O deleteAria2.sh https://raw.githubusercontent.com/Mintimate/AutoInstallAria2/main/deleteAria2.sh
echo -e "\033[32m 给自动删除日志脚本提权 \033[0m"
chmod 777 deleteAria2.sh

echo -e "\033[32m 正在进行最后部署 \033[0m"
echo -e "\033[32m ------------- \033[0m"

echo "
#用户名
#rpc-user=user
#密码
#rpc-passwd=passwd
#上面的认证方式不建议使用,建议使用下面的token方式
#设置加密的密钥
rpc-secret=${Aria2token}
#允许rpc
enable-rpc=true
#允许所有来源, web界面跨域权限需要
rpc-allow-origin-all=true
#允许外部访问，false的话只监听本地端口
rpc-listen-all=true
#RPC端口, 仅当默认端口被占用时修改
rpc-listen-port=6800
#最大同时下载数(任务数), 路由建议值: 3
max-concurrent-downloads=5
#断点续传
continue=true
#同服务器连接数
max-connection-per-server=16
#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=10M
#单文件最大线程数, 路由建议值: 5
split=128
#下载速度限制
max-overall-download-limit=0
#单文件速度限制
max-download-limit=0
#上传速度限制
max-overall-upload-limit=0
#单文件速度限制
max-upload-limit=0
#断开速度过慢的连接
#lowest-speed-limit=0
#验证用，需要1.16.1之后的release版本
#referer=*
#文件保存路径, 默认为当前启动位置
dir=${HOME}/Downloads
#文件缓存, 使用内置的文件缓存, 如果你不相信Linux内核文件缓存和磁盘内置缓存时使用, 需要1.16及以上版本
#disk-cache=0
#另一种Linux文件缓存方式, 使用前确保您使用的内核支持此选项, 需要1.15及以上版本(?)
#enable-mmap=true
#文件预分配, 能有效降低文件碎片, 提高磁盘性能. 缺点是预分配时间较长
#所需时间 none < falloc ? trunc << prealloc, falloc和trunc需要文件系统和内核支持
file-allocation=prealloc
###BT 相关

#启用本地节点查找
bt-enable-lpd=true
#添加额外的 tracker
bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.internetwarriors.net:1337/announce,http://tracker.internetwarriors.net:1337/announce,udp://tracker.opentrackr.org:1337/announce,udp://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,http://tracker.opentrackr.org:1337/announce,http://tracker3.itzmx.com:6961/announce,http://tracker1.itzmx.com:8080/announce,udp://tracker.openbittorrent.com:80/announce,udp://exodus.desync.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.tiny-vps.com:6969/announce,udp://retracker.lanta-net.ru:2710/announce,udp://open.demonii.si:1337/announce,udp://tracker2.itzmx.com:6961/announce,udp://denis.stalker.upeer.me:6969/announce,http://tracker2.itzmx.com:6961/announce,udp://tracker.cyberia.is:6969/announce,udp://open.stealth.si:80/announce,udp://explodie.org:6969/announce,udp://bt.xxx-tracker.com:2710/announce,http://explodie.org:6969/announce,http://open.acgnxtracker.com:80/announce,http://tracker4.itzmx.com:2710/announce,udp://tracker.iamhansen.xyz:2000/announce,udp://ipv4.tracker.harry.lu:80/announce,http://retracker.mgts.by:80/announce,udp://zephir.monocul.us:6969/announce,udp://tracker.uw0.xyz:6969/announce,udp://tracker.tvunderground.org.ru:3218/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.filepit.to:6969/announce,udp://torrentclub.tech:6969/announce,udp://retracker.baikal-telecom.net:2710/announce,http://tracker.tvunderground.org.ru:3218/announce,http://torrentclub.tech:6969/announce,http://t.nyaatracker.com:80/announce,udp://tracker.lelux.fi:6969/announce,https://tracker.lelux.fi:443/announce,http://tracker.lelux.fi:80/announce,http://open.trackerlist.xyz:80/announce,udp://tracker.trackton.ga:7070/announce,udp://tracker.supertracker.net:1337/announce,udp://tracker.nyaa.uk:6969/announce,udp://tracker.nibba.trade:1337/announce,udp://tracker.fixr.pro:6969/announce,udp://tracker.filemail.com:6969/announce,udp://tracker-udp.gbitt.info:80/announce,udp://retracker.sevstar.net:2710/announce,udp://retracker.netbynet.ru:2710/announce,udp://retracker.akado-ural.ru:80/announce,udp://newtoncity.org:6969/announce,https://tracker.vectahosting.eu:2053/announce,https://tracker.publictorrent.net:443/announce,https://tracker.gbitt.info:443/announce,https://tracker.fastdownload.xyz:443/announce,https://t.quic.ws:443/announce,https://opentracker.co:443/announce,http://tracker01.loveapp.com:6789/announce,http://tracker.torrentyorg.pl:80/announce,http://tracker.publictorrent.net:80/announce,http://tracker.gbitt.info:80/announce,http://tracker.bt4g.com:2095/announce,http://torrent.nwps.ws:80/announce,http://retracker.sevstar.net:2710/announce,http://open.acgtracker.com:1096/announce,http://newtoncity.org:6969/announce,http://gwp2-v19.rinet.ru:80/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker.msm8916.com:6969/announce,udp://tracker.justseed.it:1337/announce,udp://retracker.maxnet.ua:80/announce,udp://pubt.in:2710/announce,udp://chihaya.toss.li:9696/announce,udp://bt.dy20188.com:80/announce,https://1337.abcvg.info:443/announce,http://vps02.net.orel.ru:80/announce,http://tracker.bz:80/announce,http://t.acg.rip:6699/announce,http://sub4all.org:2710/announce
#单种子最大连接数
#bt-max-peers=55
#强制加密, 防迅雷必备
#bt-require-crypto=true
#当下载的文件是一个种子(以.torrent 结尾)时, 自动下载 BT
follow-torrent=true
#BT 监听端口, 当端口屏蔽时使用
#listen-port=6881-6999
#aria2 亦可以用于 PT 下载, 下载的关键在于伪装
#不确定是否需要，为保险起见， need more test
enable-dht=false
bt-enable-lpd=false
enable-peer-exchange=false
#修改特征
user-agent=uTorrent/2210(25130)
peer-id-prefix=-UT2210-
#修改做种设置, 允许做种
seed-ratio=0
#保存会话
force-save=true
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true
#定时保存会话，需要 1.16.1 之后的某个 release 版本（比如 1.16.2 ）
#save-session-interval=60
#最小做种时间
seed-time=0
# 下载好后自动执行脚本
on-download-complete=/etc/aria2/deleteAria2.sh
" >aria2.conf

echo "
aria2c --conf-path="/etc/aria2.conf"
" >${HOME}/aria2.sh

cd ../
sudo mv * /etc/aria2
cd ../

echo -e "\033[32m 放权文件权限 \033[0m"
echo -e "\033[32m ------------- \033[0m"
sudo chmod 777 ${HOME}/aria2.sh
sudo rm -rf Aria2.tar.bz2
sudo rm -rf AutoInsatllAria2ForLinux.sh
sudo rm -rf Aria2Temp

echo -e "\033[31m Aria2安装地址： \033[0m"
echo -e "\033[32m /etc/aria2 \033[0m"
echo "————————————————————————————————————————"
echo -e "\033[31m Aria2配置文件所在地址： \033[0m"
echo -e "\033[32m /etc/aria2/aria2.conf \033[0m"
echo "————————————————————————————————————————"
echo -e "\033[31m Aria2默认下载地址： \033[0m"
echo -e "\033[32m ${HOME}/Downloads \033[0m"
echo "————————————————————————————————————————"
echo -e "\033[32m
    脚本执行完成，请在当前目录通过下列命令：
    bash aria2.sh
    启动Aria2后台程序
    
    也可以配置环境变量：
    export PATH=\$PATH:/etc/aria2
    
    更多教程：
    Mintimate's Blog:
    https://www.mintimate.cn
    
    Mintimate's Bilibili:
    https://space.bilibili.com/355567627
 \033[0m"
 
echo "删除本脚本带来的残留文件"
echo "删除成功，愉快使用Aria2吧( ´▽｀)"
unlink $0
