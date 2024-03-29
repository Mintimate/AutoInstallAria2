#!/bin/bash
# Description:

# Author: @Mintimate
# Blog: https://www.mintimate.cn/about

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

function judgeArchitecture(){
    echo -e "\033[31m 判断系统架构 \033[0m"
    echo -e "\033[32m 正在下载( ´▽｀) \033[0m"
    OS="$(uname -m)"
    case $OS in
    aarch64 | arm64 | arm )
        wget -qO ${shellPath}/Aria2.tar.bz2 "https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/aria2-1.35.0-linux-gnu-arm-rbpi-build1.tar.bz2"
        ;;
    x86_64 | x64 )
        wget -qO ${shellPath}/Aria2.tar.bz2 "https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2"
        ;;
    *)
        echo -e "\033[31m 未知Linux架构，请手动选择： \033[0m"
        echo "1:x86 32位的Linux"
        echo "2:x86 64位的Linux"
        echo "3:ARM 架构的Linux"
        echo "0或其他按键：其他工具包"
        read temp
        if [ ${temp} -eq "1" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/aria2-1.35.0-linux-gnu-32bit-build1.tar.bz2"
        elif [ ${temp} -eq "2" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/aria2-1.35.0-linux-gnu-64bit-build1.tar.bz2"
        elif [ ${temp} -eq "3" ]; then
            wget -qO ${shellPath}/Aria2.tar.bz2 "https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/aria2-1.35.0-linux-gnu-arm-rbpi-build1.tar.bz2"
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
    echo -e "\033[32m 下载目录已经存在 \033[0m"
else
    echo -e "\033[32m 创建下载目录 \033[0m"
    mkdir ${HOME}/Downloads
fi

# 配置自动删除日志脚本
echo -e "\033[32m 配置自动删除日志脚本 \033[0m"
wget -O deleteAria2.sh https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/deleteAria2.sh
echo -e "\033[32m 给自动删除日志脚本提权 \033[0m"
chmod 777 deleteAria2.sh

echo -e "\033[32m 下载dht => 用来解析磁力链接 \033[0m"
wget https://cdn.jsdelivr.net/gh/Mintimate/AutoInstallAria2@latest/dht.dat

echo -e "\033[32m 正在进行最后部署 \033[0m"
echo -e "\033[32m ------------- \033[0m"

echo "
## 文件保存设置 ##

#文件保存路径, 默认为当前启动位置;当前为家目录下Downlaods文件夹
dir=${HOME}/Downloads


# 文件预分配方式, 可选：none, prealloc, trunc, falloc, 默认:prealloc
# 预分配对于机械硬盘可有效降低磁盘碎片、提升磁盘读写性能、延长磁盘寿命。
# 机械硬盘使用 ext4（具有扩展支持），btrfs，xfs 或 NTFS（仅 MinGW 编译版本）等文件系统建议设置为 falloc
# 若无法下载，提示 fallocate failed.cause：Operation not supported 则说明不支持，请设置为 none
# prealloc 分配速度慢, trunc 无实际作用，不推荐使用。
# 固态硬盘不需要预分配，只建议设置为 none ，否则可能会导致双倍文件大小的数据写入，从而影响寿命。
file-allocation=none

#断点续传
continue=true

# 始终尝试断点续传，无法断点续传则终止下载，默认：true
always-resume=false

# 强制保存，即使任务已完成也保存信息到会话文件, 默认:false
# 开启后会在任务完成后保留 .aria2 文件，文件被移除且任务存在的情况下重启后会重新下载。
# 关闭后已完成的任务列表会在重启后清空。
force-save=false

## 下载连接设置 ##

# 文件未找到重试次数，默认:0 (禁用)
# 重试时同时会记录重试次数，所以也需要设置 max-tries 这个选项
max-file-not-found=10

# 最大尝试次数，0 表示无限，默认:5
max-tries=0

# 重试等待时间（秒）, 默认:0 (禁用)
retry-wait=10

# 连接超时时间（秒）。默认：60
connect-timeout=10

# 超时时间（秒）。默认：60
timeout=10

# 最大同时下载任务数, 运行时可修改, 默认:5
max-concurrent-downloads=5

# 单服务器最大连接线程数, 任务添加时可指定, 默认:1
# 最大值为 16 (增强版无限制), 且受限于单任务最大连接线程数(split)所设定的值。
max-connection-per-server=16

# 单任务最大连接线程数, 任务添加时可指定, 默认:5
split=64

# 文件最小分段大小, 添加时可指定, 取值范围 1M-1024M (增强版最小值为 1K), 默认:20M
# 比如此项值为 10M, 当文件为 20MB 会分成两段并使用两个来源下载, 文件为 15MB 则只使用一个来源下载。
# 理论上值越小使用下载分段就越多，所能获得的实际线程数就越大，下载速度就越快，但受限于所下载文件服务器的策略。
min-split-size=4M

# HTTP/FTP 下载分片大小，所有分割都必须是此项值的倍数，最小值为 1M (增强版为 1K)，默认：1M
piece-length=1M

# 允许分片大小变化。默认：false
# false：当分片大小与控制文件中的不同时将会中止下载
# true：丢失部分下载进度继续下载
allow-piece-length-change=true

# 最低下载速度限制。当下载速度低于或等于此选项的值时关闭连接（增强版本为重连），此选项与 BT 下载无关。单位 K 或 M ，默认：0 (无限制)
lowest-speed-limit=0

# 全局最大下载速度限制, 运行时可修改, 默认：0 (无限制)
max-overall-download-limit=0

# 单任务下载速度限制, 默认：0 (无限制)
max-download-limit=0

# 禁用 IPv6, 默认:false
disable-ipv6=false

# GZip 支持，默认:false
http-accept-gzip=true

# URI 复用，默认: true
reuse-uri=false

# 禁用 netrc 支持，默认:false
no-netrc=true

# 允许覆盖，当相关控制文件(.aria2)不存在时从头开始重新下载。默认:false
allow-overwrite=false

# 使用 UTF-8 处理 Content-Disposition ，默认:false
content-disposition-default-utf8=true

# 最低 TLS 版本，可选：TLSv1.1、TLSv1.2、TLSv1.3 默认:TLSv1.2
#min-tls-version=TLSv1.2

## BT/PT 下载设置 ##
# 启用 IPv4 DHT 功能, PT 下载(私有种子)会自动禁用, 默认:true
enable-dht=true

# 启用 IPv6 DHT 功能, PT 下载(私有种子)会自动禁用，默认:false
# 在没有 IPv6 支持的环境开启可能会导致 DHT 功能异常
enable-dht6=true

# 指定 BT 和 DHT 网络中的 IP 地址
# 使用场景：在家庭宽带没有公网 IP 的情况下可以把 BT 和 DHT 监听端口转发至具有公网 IP 的服务器，在此填写服务器的 IP ，可以提升 BT 下载速率。
#bt-external-ip=

# IPv4 DHT 文件路径，默认：\$HOME/.aria2/dht.dat
dht-file-path=/etc/aria2/dht.dat

# IPv6 DHT 文件路径，默认：\$HOME/.aria2/dht6.dat
dht-file-path6=/etc/aria2/dht.dat


# 本地节点发现, PT 下载(私有种子)会自动禁用 默认:false
bt-enable-lpd=true

# 指定用于本地节点发现的接口，可能的值：接口，IP地址
# 如果未指定此选项，则选择默认接口。
#bt-lpd-interface=

# 启用节点交换, PT 下载(私有种子)会自动禁用, 默认:true
enable-peer-exchange=true

# BT 下载最大连接数（单任务），运行时可修改。0 为不限制，默认:55
# 理想情况下连接数越多下载越快，但在实际情况是只有少部分连接到的做种者上传速度快，其余的上传慢或者不上传。
# 如果不限制，当下载非常热门的种子或任务数非常多时可能会因连接数过多导致进程崩溃或网络阻塞。
# 进程崩溃：如果设备 CPU 性能一般，连接数过多导致 CPU 占用过高，因资源不足 Aria2 进程会强制被终结。
# 网络阻塞：在内网环境下，即使下载没有占满带宽也会导致其它设备无法正常上网。因远古低性能路由器的转发性能瓶颈导致。
bt-max-peers=128

# BT 下载期望速度值（单任务），运行时可修改。单位 K 或 M 。默认:50K
# BT 下载速度低于此选项值时会临时提高连接数来获得更快的下载速度，不过前提是有更多的做种者可供连接。
# 实测临时提高连接数没有上限，但不会像不做限制一样无限增加，会根据算法进行合理的动态调节。
bt-request-peer-speed-limit=10M

# 全局最大上传速度限制, 运行时可修改, 默认:0 (无限制)
# 设置过低可能影响 BT 下载速度
max-overall-upload-limit=2M

# 单任务上传速度限制, 默认:0 (无限制)
max-upload-limit=0

# 最小分享率。当种子的分享率达到此选项设置的值时停止做种, 0 为一直做种, 默认:1.0
# 强烈建议您将此选项设置为大于等于 1.0
seed-ratio=1.0

# 最小做种时间（分钟）。设置为 0 时将在 BT 任务下载完成后停止做种。
seed-time=0

# 做种前检查文件哈希, 默认:true
bt-hash-check-seed=true

# 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=false

# BT tracker 服务器连接超时时间（秒）。默认：60
# 建立连接后，此选项无效，将使用 bt-tracker-timeout 选项的值
bt-tracker-connect-timeout=10

# BT tracker 服务器超时时间（秒）。默认：60
bt-tracker-timeout=10

# BT 服务器连接间隔时间（秒）。默认：0 (自动)
#bt-tracker-interval=0

# BT 下载优先下载文件开头或结尾
bt-prioritize-piece=head=32M,tail=32M

# 保存通过 WebUI(RPC) 上传的种子文件(.torrent)，默认:true
# 所有涉及种子文件保存的选项都建议开启，不保存种子文件有任务丢失的风险。
# 通过 RPC 自定义临时下载目录可能不会保存种子文件。
rpc-save-upload-metadata=true

# 下载种子文件(.torrent)自动开始下载, 默认:true，可选：false|mem
# true：保存种子文件
# false：仅下载种子文件
# mem：将种子保存在内存中
follow-torrent=true

# 种子文件下载完后暂停任务，默认：false
# 在开启 follow-torrent 选项后下载种子文件或磁力会自动开始下载任务进行下载，而同时开启当此选项后会建立相关任务并暂停。
pause-metadata=false

# 保存磁力链接元数据为种子文件(.torrent), 默认:false
bt-save-metadata=true

# 加载已保存的元数据文件(.torrent)，默认:false
bt-load-saved-metadata=true

# 删除 BT 下载任务中未选择文件，默认:false
bt-remove-unselected-file=true

# BT强制加密, 默认: false
# 启用后将拒绝旧的 BT 握手协议并仅使用混淆握手及加密。可以解决部分运营商对 BT 下载的封锁，且有一定的防版权投诉与迅雷吸血效果。
# 此选项相当于后面两个选项(bt-require-crypto=true, bt-min-crypto-level=arc4)的快捷开启方式，但不会修改这两个选项的值。
bt-force-encryption=true

# BT加密需求，默认：false
# 启用后拒绝与旧的 BitTorrent 握手协议(\19BitTorrent protocol)建立连接，始终使用混淆处理握手。
#bt-require-crypto=true

# BT最低加密等级，可选：plain（明文），arc4（加密），默认：plain
#bt-min-crypto-level=arc4

# 分离仅做种任务，默认：false
# 从正在下载的任务中排除已经下载完成且正在做种的任务，并开始等待列表中的下一个任务。
bt-detach-seed-only=true

## 客户端伪装 ##

# 自定义 User Agent
user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36 Edg/87.0.664.57

# BT 客户端伪装
# PT 下载需要保持 user-agent 和 peer-agent 两个参数一致
# 部分 PT 站对 Aria2 有特殊封禁机制，客户端伪装不一定有效，且有封禁账号的风险。
#user-agent=Transmission 2.94
peer-agent=Transmission 2.94
peer-id-prefix=-TR2940-

## RPC 设置 ##

# 启用 JSON-RPC/XML-RPC 服务器, 默认:false
enable-rpc=true

# 接受所有远程请求, 默认:false
rpc-allow-origin-all=true

# 允许外部访问, 默认:false
rpc-listen-all=true

# RPC 监听端口, 默认:6800
rpc-listen-port=6800

#设置加密的密钥
rpc-secret=${Aria2token}

# RPC 最大请求大小
rpc-max-request-size=10M

# RPC 服务 SSL/TLS 加密, 默认：false
# 启用加密后必须使用 https 或者 wss 协议连接
# 不推荐开启，建议使用 web server 反向代理，比如 Nginx、Caddy ，灵活性更强。
#rpc-secure=false

# 事件轮询方式, 可选：epoll, kqueue, port, poll, select, 不同系统默认值不同
#event-poll=select

## 高级选项 ##

# 启用异步 DNS 功能。默认：true
#async-dns=true

# 指定异步 DNS 服务器列表，未指定则从 /etc/resolv.conf 中读取。
#async-dns-server=119.29.29.29,223.5.5.5,8.8.8.8,1.1.1.1

# 指定单个网络接口，可能的值：接口，IP地址，主机名
# 如果接口具有多个 IP 地址，则建议指定 IP 地址。
# 已知指定网络接口会影响依赖本地 RPC 的连接的功能场景，即通过 localhost 和 127.0.0.1 无法与 Aria2 服务端进行讯通。
#interface=

# 指定多个网络接口，多个值之间使用逗号(,)分隔。
# 使用 interface 选项时会忽略此项。
#multiple-interface=

## 执行额外命令 ##

# 下载停止后执行的命令
# 从 正在下载 到 删除、错误、完成 时触发。暂停被标记为未开始下载，故与此项无关。
on-download-stop=/etc/aria2/deleteAria2.sh

# 下载完成后执行的命令
# 此项未定义则执行 下载停止后执行的命令 (on-download-stop)
on-download-complete=/etc/aria2/deleteAria2.sh

# 下载错误后执行的命令
# 此项未定义则执行 下载停止后执行的命令 (on-download-stop)
#on-download-error=

# 下载暂停后执行的命令
#on-download-pause=

# 下载开始后执行的命令
#on-download-start=

## BitTorrent trackers ##
bt-tracker=http://1337.abcvg.info:80/announce,http://159.69.65.157:6969/announce,http://185.148.3.231:80/announce,http://185.185.40.129:6969/announce,http://185.230.4.150:1337/announce,http://51.222.84.64:1337/announce,http://51.79.71.167:80/announce,http://51.81.46.170:6969/announce,http://54.39.179.91:6699/announce,http://60-fps.org:80/bt:80/announce.php,http://78.30.254.12:2710/announce,http://82.65.37.128:6969/announce,http://93.158.213.92:1337/announce,http://95.107.48.115:80/announce,http://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,http://[2001:470:1:189:0:1:2:3]:6969/announce,http://[2a04:ac00:1:3dd8::1:2710]:2710/announce,http://all4nothin.net:80/announce.php,http://atrack.pow7.com:80/announce,http://big-boss-tracker.net:80/announce.php,http://bluebird-hd.org:80/announce.php,http://bt-club.ws:80/announce,http://bt.3dmgame.com:2710/announce,http://bt.ali213.net:8080/announce,http://bt.okmp3.ru:2710/announce,http://bt.rghost.net:80/announce,http://bt.unionpeer.org:777/announce,http://bt.zlofenix.org:81/announce,http://btx.anifilm.tv:80/announce.php,http://carbon-bonsai-621.appspot.com:80/announce,http://concen.org:6969/announce,http://data-bg.net:80/announce.php,http://explodie.org:6969/announce,http://fxtt.ru:80/announce,http://googer.cc:1337/announce,http://h4.trakx.nibba.trade:80/announce,http://irrenhaus.dyndns.dk:80/announce.php,http://kinorun.com:80/announce.php,http://masters-tb.com:80/announce.php,http://mediaclub.tv:80/announce.php,http://milanesitracker.tekcities.com:80/announce,http://mixfiend.com:6969/announce,http://mvgroup.org:2710/announce,http://ns349743.ip-91-121-106.eu:80/announce,http://nyaa.tracker.wf:7777/announce,http://open.acgnxtracker.com:80/announce,http://openbittorrent.com:80/announce,http://opentracker.i2p.rocks:6969/announce,http://opentracker.xyz:80/announce,http://p4p.arenabg.com:1337/announce,http://pow7.com:80/announce,http://proaudiotorrents.org:80/announce.php,http://retracker.hotplug.ru:2710/announce,http://retracker.spark-rostov.ru:80/announce,http://retracker.telecom.by:80/announce,http://secure.pow7.com:80/announce,http://share.camoe.cn:8080/announce,http://siambit.com:80/announce.php,http://t.acg.rip:6699/announce,http://t.nyaatracker.com:80/announce,http://t.overflow.biz:6969/announce,http://t1.pow7.com:80/announce,http://torrent-team.net:80/announce.php,http://torrent.arjlover.net:2710/announce,http://torrent.fedoraproject.org:6969/announce,http://torrent.mp3quran.net:80/announce.php,http://torrent.resonatingmedia.com:6969/announce,http://torrents.linuxmint.com:80/announce.php,http://torrentsmd.com:8080/announce,http://torrentzilla.org:80/announce,http://torrentzilla.org:80/announce.php,http://tr.cili001.com:8070/announce,http://tracker.ali213.net:8000/announce,http://tracker.anirena.com:80/announce,http://tracker.birkenwald.de:6969/announce,http://tracker.bittor.pw:1337/announce,http://tracker.breizh.pm:6969/announce,http://tracker.bt4g.com:2095/announce,http://tracker.dler.org:6969/announce,http://tracker.files.fm:6969/announce,http://tracker.frozen-layer.net:6969/announce,http://tracker.gbitt.info:80/announce,http://tracker.gcvchp.com:2710/announce,http://tracker.gigatorrents.ws:2710/announce,http://tracker.grepler.com:6969/announce,http://tracker.ipv6tracker.org:80/announce,http://tracker.ipv6tracker.ru:80/announce,http://tracker.loadbt.com:6969/announce,http://tracker.minglong.org:8080/announce,http://tracker.noobsubs.net:80/announce,http://tracker.openbittorrent.com:80/announce,http://tracker.opentrackr.org:1337/announce,http://tracker.pussytorrents.org:3000/announce,http://tracker.tambovnet.org:80/announce.php,http://tracker.tasvideos.org:6969/announce,http://tracker.tfile.me:80/announce,http://tracker.torrentbytes.net:80/announce.php,http://tracker.trackerfix.com:80/announce,http://tracker.xdvdz.com:2710/announce,http://tracker.yowe.net:80/announce,http://tracker.zerobytes.xyz:1337/announce,http://tracker1.bt.moack.co.kr:80/announce,http://tracker2.dler.org:80/announce,http://tracker3.dler.org:2710/announce,http://vps02.net.orel.ru:80/announce,http://www.all4nothin.net:80/announce.php,http://www.legittorrents.info:80/announce.php,http://www.shnflac.net:80/announce.php,http://www.thetradersden.org/forums/tracker:80/announce.php,http://www.tribalmixes.com:80/announce.php,http://www.tvnihon.com:6969/announce,http://www.xwt-classics.net:80/announce.php,http://www.zone-torrent.net:80/announce.php,https://1337.abcvg.info:443/announce,https://carbon-bonsai-621.appspot.com:443/announce,https://mytracker.fly.dev:443/announce,https://open.kickasstracker.com:443/announce,https://opentracker.acgnx.se:443/announce,https://opentracker.xyz:443/announce,https://tr.torland.ga:443/announce,https://tracker.bt-hash.com:443/announce,https://tracker.coalition.space:443/announce,https://tracker.foreverpirates.co:443/announce,https://tracker.iriseden.eu:443/announce,https://tracker.iriseden.fr:443/announce,https://tracker.lilithraws.cf:443/announce,https://tracker.nitrix.me:443/announce,https://tracker.shittyurl.org:443/announce,https://tracker.tamersunion.org:443/announce,https://trakx.herokuapp.com:443/announce,https://w.wwwww.wtf:443/announce,udp://103.196.36.31:6969/announce,udp://104.244.72.77:1337/announce,udp://119.28.134.203:6969/announce,udp://149.28.47.87:1738/announce,udp://156.234.201.18:80/announce,udp://159.69.208.124:6969/announce,udp://163.172.170.127:6969/announce,udp://167.179.77.133:1/announce,udp://176.96.139.154:8080/announce,udp://184.105.151.166:6969/announce,udp://185.181.60.67:80/announce,udp://185.183.158.105:6969/announce,udp://185.21.216.185:6969/announce,udp://185.8.156.2:6969/announce,udp://185.92.223.36:6969/announce,udp://195.201.94.195:6969/announce,udp://198.100.149.66:6969/announce,udp://199.217.118.72:6969/announce,udp://205.185.121.146:6969/announce,udp://208.83.20.20:6969/announce,udp://209.141.59.16:6969/announce,udp://212.1.226.176:2710/announce,udp://213.108.129.160:6969/announce,udp://37.235.174.46:2710/announce,udp://37.59.48.81:6969/announce,udp://45.154.253.4:6969/announce,udp://46.148.18.252:2710/announce,udp://5.181.49.163:6969/announce,udp://51.15.2.221:6969/announce,udp://51.15.3.74:6969/announce,udp://51.15.55.204:1337/announce,udp://52.58.128.163:6969/announce,udp://65.21.48.148:6969/announce,udp://67.224.119.27:6969/announce,udp://6ahddutb1ucc3cp.ru:6969/announce,udp://78.30.254.12:2710/announce,udp://88.99.142.4:8000/announce,udp://89.234.156.205:451/announce,udp://89.36.216.8:6969/announce,udp://9.rarbg.com:2720/announce,udp://9.rarbg.com:2810/announce,udp://9.rarbg.me:2710/announce,udp://9.rarbg.to:2710/announce,udp://91.121.145.207:6969/announce,udp://91.149.192.31:6969/announce,udp://91.216.110.52:451/announce,udp://95.181.152.224:6969/announce,udp://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,udp://[2001:470:1:189:0:1:2:3]:6969/announce,udp://[2a03:7220:8083:cd00::1]:451/announce,udp://[2a04:ac00:1:3dd8::1:2710]:2710/announce,udp://[2a0f:e586:f:f::220]:6969/announce,udp://abufinzio.monocul.us:6969/announce,udp://admin.videoenpoche.info:6969/announce,udp://anidex.moe:6969/announce,udp://app.icon256.com:8000/announce,udp://bt.100.pet:2711/announce,udp://bt2.54new.com:8080/announce,udp://btt.service.gongt.me:43079/announce,udp://bubu.mapfactor.com:6969/announce,udp://code2chicken.nl:6969/announce,udp://concen.org:6969/announce,udp://cutiegirl.ru:6969/announce,udp://discord.heihachi.pw:6969/announce,udp://engplus.ru:6969/announce,udp://exodus.desync.com:6969/announce,udp://explodie.org:6969/announce,udp://fe.dealclub.de:6969/announce,udp://ipv6.tracker.zerobytes.xyz:16661/announce,udp://mail.realliferpg.de:6969/announce,udp://movies.zsw.ca:6969/announce,udp://mts.tvbit.co:6969/announce,udp://open.demonii.com:1337/announce,udp://open.publictracker.xyz:6969/announce,udp://open.stealth.si:80/announce,udp://opentor.org:2710/announce,udp://opentracker.i2p.rocks:6969/announce,udp://opentrackr.org:1337/announce,udp://p4p.arenabg.com:1337/announce,udp://peerfect.org:6969/announce,udp://pow7.com:80/announce,udp://public.publictracker.xyz:6969/announce,udp://retracker.hotplug.ru:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://retracker.netbynet.ru:2710/announce,udp://retracker.nts.su:2710/announce,udp://retracker.sevstar.net:2710/announce,udp://t1.leech.ie:1337/announce,udp://thetracker.org:80/announce,udp://tr.bangumi.moe:6969/announce,udp://tracker-de.ololosh.space:6969/announce,udp://tracker.0x.tf:6969/announce,udp://tracker.aletorrenty.pl:2710/announce,udp://tracker.altrosky.nl:6969/announce,udp://tracker.army:6969/announce,udp://tracker.beeimg.com:6969/announce,udp://tracker.birkenwald.de:6969/announce,udp://tracker.bittor.pw:1337/announce,udp://tracker.blacksparrowmedia.net:6969/announce,udp://tracker.breizh.pm:6969/announce,udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.dler.com:6969/announce,udp://tracker.dler.org:6969/announce,udp://tracker.eddie4.nl:6969/announce,udp://tracker.edkj.club:6969/announce,udp://tracker.filemail.com:6969/announce,udp://tracker.flashtorrents.org:6969/announce,udp://tracker.grepler.com:6969/announce,udp://tracker.halfchub.club:6969/announce,udp://tracker.kuroy.me:5944/announce,udp://tracker.leech.ie:1337/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://tracker.loadbt.com:6969/announce,udp://tracker.moeking.eu.org:6969/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.monitorit4.me:6969/announce,udp://tracker.nrx.me:6969/announce,udp://tracker.ololosh.space:6969/announce,udp://tracker.open-internet.nl:6969/announce,udp://tracker.openbittorrent.com:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://tracker.pomf.se:80/announce,udp://tracker.sbsub.com:2710/announce,udp://tracker.sktorrent.net:6969/announce,udp://tracker.skyts.net:6969/announce,udp://tracker.swateam.org.uk:2710/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.uw0.xyz:6969/announce,udp://tracker.vanitycore.co:6969/announce,udp://tracker.zemoj.com:6969/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker0.ufibox.com:6969/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker2.dler.com:80/announce,udp://tracker2.dler.org:80/announce,udp://tracker4.itzmx.com:2710/announce,udp://u.wwwww.wtf:1/announce,udp://udp-tracker.shittyurl.org:6969/announce,udp://vibe.community:6969/announce,udp://vibe.sleepyinternetfun.xyz:1738/announce,udp://wassermann.online:6969/announce,udp://www.mvgroup.org:2710/announce,udp://www.torrent.eu.org:451/announce,wss://tracker.files.fm:7073/announce,wss://tracker.openwebtorrent.com:443/announce
" >aria2.conf

aria2Shell=${HOME}/aria2.sh
echo "
/etc/aria2/aria2c --conf-path="/etc/aria2/aria2.conf"
" >${aria2Shell}

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
echo -e "\033[31m Aria2一键运行脚本地址： \033[0m"
echo -e "\033[32m ${HOME}/aria2.sh \033[0m"
echo "————————————————————————————————————————"
echo -e "\033[32m
    脚本执行完成，请在${HOME}目录通过下列命令：
    bash aria2.sh
    启动Aria2后台程序
    
    如果想任意目录使用Aria2，配置环境变量：
    export PATH=\$PATH:/etc/aria2
    
    更多教程：
    Mintimate's Blog:
    https://www.mintimate.cn
    
    Mintimate's Bilibili:
    https://space.bilibili.com/355567627
 \033[0m"
 
echo "删除本脚本带来的残留文件ing"
echo "愉快使用Aria2吧( ´▽｀)"
unlink $0
