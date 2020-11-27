#!/bin/bash
# Linux工具包，默认apt-get
method="None"
# 环境地址
shellPath=`pwd`

echo -e "\033[32m
    Aria2简单编译配置脚本
    作者：Mintimate
   
    使用本脚本可以一键在Linux上配置Aria2
    获取帮助：
    QQ：198330181
    
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

# 判断Linux系统版本
source /etc/os-release
case $ID in
debian|ubuntu|devuan)
    method="apt-get"
    ;;
centos|fedora|rhel)
    yumdnf="yum"
    if test "$(echo "$VERSION_ID >= 22" | bc)" -ne 0; then
        yumdnf="dnf"
    fi
    method=yumdnf
    ;;
*)
echo -e "\033[31m 未知Linux版本，请手动选择： \033[0m"
echo "1:使用apt-get工具包的Linux"
echo "2:使用yum工具包的Linux"
echo "3:使用dnf工具包的Linux"
echo "0或其他按键：其他工具包"
read temp
if [ ${temp} -eq "1" ]
then
    method="apt-get"
elif [ ${temp} -eq "2" ]
then
    method="yum"
elif [ ${temp} -eq "3" ]
then
    method="dnf"
else
    method="None"
fi
    ;;
esac

# 判断是否支持该脚本
if [ ${method} == "None" ]
then
    echo -e "\033[31m 你的系统不支持该脚本 \033[0m"
    echo -e "\033[31m 请联系我： \033[0m"
    echo -e "\033[31m QQ：198330181 \033[0m"
    exit
fi

# 安装依赖
echo -e "\033[32m 安装依赖啦 \033[0m"
if [ method == "apt-get" ]
then
    echo -e "\033[32m 安装依赖：build-essential \033[0m"
    apt-get update && apt-get install build-essential -y  >> /dev/null 2>&1
else
    ${method} update && ${method} groupinstall "Development Tools" >> /dev/null 2>&1
fi


# 下载Aria2源文件
echo -e "\033[32m 下载远程配置Aria2源码 \033[0m"
echo -e "\033[32m 正在下载( ´▽｀) \033[0m"
wget -qO ${shellPath}/Aria2.zip "http://150.158.155.98:8080/fileHost/download/96"


echo -e "\033[32m 解压Aria2文件 \033[0m"
unzip ${shellPath}/Aria2.zip

# 重命名文件
mv aria2-1.35.0-linux-gnu-64bit-build1 Aria2
# 切换脚本目录到Aria2文件内
cd ${shellPath}/Aria2
shellPath=`pwd`

echo -e "\033[32m 编译Aria2到系统 \033[0m"
make install >> /dev/null 2>&1
echo -e "\033[32m 提权 \033[0m"
chmod +x aria2c


mkdir ../Aria2Downloads #下载文件存储目录
mkdir .aria2  #配置文件存放目录

# 配置自动删除日志脚本
echo -e "\033[32m 配置自动删除日志脚本 \033[0m"
wget -O .aria2/deleteAria2.sh https://gitee.com/mintimate/auto-install-aria2/raw/master/deleteAria2.sh

echo -e "\033[32m 最后部署 \033[0m"


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
dir=${shellPath}/Download
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
on-download-complete=${shellPath}/.aria2/deleteAria2.sh
" > .aria2/aria2.conf

echo "
aria2c --conf-path="${shellPath}/.aria2/aria2.conf"
" > ../aria2.sh


echo -e "\033[31m Aria2配置文件所在地址： \033[0m"
echo -e "\033[32m ${shellPath}/.aria2/aria2.conf \033[0m"
echo "————————————————————————————————————————"
echo -e "\033[32m
    脚本执行完成，请在当前目通过下列命令：
    bash aria2.sh
    启动Aria2后台程序
    
    更多教程：
    Mintimate's Blog:
    https://www.mintimate.cn
    
    Mintimate's Bilibili:
    https://space.bilibili.com/355567627
 \033[0m"
