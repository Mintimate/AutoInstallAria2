#!/bin/bash
# Description:

# Author: @Mintimate
# Blog: https://www.mintimate.cn/about

# 部署的路径
ProjectPath="${ROOT_PATH:-$HOME/aria2Auto}"
rm -rf ${ProjectPath} && mkdir -p ${ProjectPath}
# 下载的目标地址
DownloadTarget="${DOWNLOAD_PATH:-$HOME/Downloads}"
mkdir -p ${DownloadTarget}
# echo 标准化
RED='\033[0;31m'    # 红色
GREEN='\033[0;32m'  # 绿色
YELLOW='\033[0;33m' # 黄色
NC='\033[0m'        # 重置颜色


printMintimate() {
    echo -e "${GREEN}
_____________________________________________________________
    _   _
    /  /|     ,                 ,
---/| /-|----------__---_/_---------_--_-----__---_/_-----__-
  / |/  |   /    /   )  /     /    / /  )  /   )  /     /___)
_/__/___|__/____/___/__(_ ___/____/_/__/__(___(__(_ ___(___ _
         Mintimate's Blog:https://www.mintimate.cn
_____________________________________________________________${NC}"
    echo -e "${GREEN}
    Aria2快速配置脚本
    作者：Mintimate
   
    使用本脚本可以一键在Linux上配置Aria2
    获取帮助 -> QQ：198330181
    （限：求助前，有给我视频三连的粉丝用户）

    捐赠和赞赏：
    https://www.afdian.com/a/mintimate
    
    更多教程：
    Mintimate's Blog:
    https://www.mintimate.cn
    
    Mintimate's Bilibili:
    https://space.bilibili.com/355567627${NC}"
}

judgeArchitecture(){
    echo -e "${GREEN} 下载远程配置Aria2源码 ${NC}"
    echo -e "${YELLOW} 判断系统架构 ${NC}"

    # 获取系统架构
    OS=$(uname -m)
    case ${OS} in
    *86)
        SYS_FLAG='i386'
        ;;
    x86_64 | amd64)
        SYS_FLAG='amd64'
        ;;
    aarch64 | arm64)
        SYS_FLAG='arm64'
        ;;
    arm*)
        SYS_FLAG='armhf'
        ;;
    *)
        echo -e "${ERROR} Unsupported architecture: ${OS}"
        exit 1
        ;;
    esac

    echo -e "${GREEN} 系统架构为：${SYS_FLAG} ${NC}"
    echo -e "${GREEN} 正在下载( ´▽｀) ${NC}"
    # aria2 预编译包下载地址
    DOWNLOAD_ARIA2_STATIC=https://cnb.cool/flyinbug/aria2-static-build/-/releases/download/v1.37.0-Turbo_20250402/aria2-static-linux-${SYS_FLAG}.tar.gz
    wget -qO ${ProjectPath}/Aria2.tar.gz ${DOWNLOAD_ARIA2_STATIC}
    if [ $? -eq 0 ]; then
        echo -e "${GREEN} 下载成功 ${NC}"
    else
        echo -e "${RED} 下载失败 ${NC}"
        exit
    fi
}

setPassword(){
    # 设置密码
    echo -e "${GREEN} 设置Aria2密码 ${NC}"
    echo -e "${RED} (用于远程Aria2认证) ${NC}"
    echo -e "${RED} (直接输入 no 退出并取消配置) ${NC}"
    read aria2Password
    if [ ${aria2Password} == "no" ];then
        echo -e "${RED} 取消配置 ${NC}"
        exit
    fi
}

touchAria2Conf(){
    echo -e "${GREEN} 解压Aria2文件 ${NC}"
    mkdir -p ${ProjectPath}/Aria2Temp
    tar -xf ${ProjectPath}/Aria2.tar.gz -C ${ProjectPath}/Aria2Temp
    echo -e "${GREEN} 创建Aria2配置文件夹: ${ProjectPath} ${NC}"
    mkdir -p ${ProjectPath}
    cp ${ProjectPath}/Aria2Temp/aria2c ${ProjectPath}/aria2c
    echo -e "${GREEN} 云端下载 aria2 配置模板 ${NC}"
    wget -qO ${ProjectPath}/aria2.conf.template https://cnb.cool/Mintimate/tool-forge/AutoInstallAria2/-/git/raw/main/template/aria2.conf.template
    wget -qO ${ProjectPath}/deleteAria2.conf https://cnb.cool/Mintimate/tool-forge/AutoInstallAria2/-/git/raw/main/template/deleteAria2.conf
    wget -qO ${ProjectPath}/aria2.service.template https://cnb.cool/Mintimate/tool-forge/AutoInstallAria2/-/git/raw/main/template/aria2.service.template
    wget -qO ${ProjectPath}/aria2.tracker.template https://cnb.cool/Mintimate/tool-forge/AutoInstallAria2/-/git/raw/main/template/aria2.tracker.template
    echo -e "${GREEN} 提权 aria2 核心 ${NC}"
    chmod +x ${ProjectPath}/aria2c
}


initAria2Conf(){
    local Aria2token="$1"
    sed \
        -e "s|__DownloadTarget__|${DownloadTarget}|g" \
        -e "s|__Aria2Home__|${ProjectPath}|g" \
        -e "s|__Aria2Token__|${Aria2token}|g" \
        ${ProjectPath}/aria2.conf.template > ${ProjectPath}/aria2.conf
    sed -i "s|bt-tracker=|bt-tracker=$(cat ${ProjectPath}/aria2.tracker.template)|" ${ProjectPath}/aria2.conf
}

registerAria2Systemctl(){
    mkdir -p ${HOME}/.config/systemd/user
    sed \
        -e "s|__Aria2Home__|${ProjectPath}|g" \
        ${ProjectPath}/aria2.service.template > ${HOME}/.config/systemd/user/aria2.service
    echo -e "${GREEN} 注册Aria2服务成功 ${NC}"
    if [[ $(systemd-detect-virt) == "container" || $(systemd-detect-virt) == "docker" ]]; then
        echo -e "${YELLOW} 当前在容器内，跳过 systemctl 服务创建 ${NC}"
    else
        systemctl --user daemon-reload
        systemctl --user enable aria2.service
        systemctl --user start aria2.service
        echo -e "${GREEN} 服务启动成功 ${NC}"
    fi
}


printResult(){
    echo -e "${GREEN} 部署完成，配置信息如下 ${NC}"
    echo -e "${GREEN} ------------- ${NC}"
    echo -e "${RED} Aria2 安装地址 ${NC}"
    echo -e "${GREEN} ${ProjectPath} ${NC}"
    echo "————————————————————————————————————————"
    echo -e "${RED} Aria2 服务注册地址 ${NC}"
    echo -e "${GREEN} ${HOME}/.config/systemd/user/aria2.service ${NC}"
    echo "————————————————————————————————————————"
    echo -e "${RED} Aria2 RPC 启动命令 ${NC}"
    echo -e "${GREEN} 非容器: systemctl --user start aria2.service ${NC}"
    echo -e "${GREEN} 容器内: ${ProjectPath}/aria2c --conf-path=${ProjectPath}/aria2.conf ${NC}"
    echo "————————————————————————————————————————"
    echo -e "${RED} Aria2 RPC 文件下载目录 ${NC}"
    echo -e "${GREEN} ${HOME}/Download ${NC}"
    echo "————————————————————————————————————————"
}

cleanUpWorkspace(){
    rm -rf ${ProjectPath}/Aria2.tar.gz
    rm -rf ${ProjectPath}/Aria2Temp    
    rm -rf ${ProjectPath}/*.template    
}

# 打印 logo 和提示信息
printMintimate
# 设置 RPC 密码
setPassword
# 下载Aria2源文件
judgeArchitecture
# 配置 Aria2 
touchAria2Conf
# 初始化 Aria2
initAria2Conf ${aria2Password}
# 注册 Aria2 服务
registerAria2Systemctl
# 打印结果
printResult
# 清理工作空间
cleanUpWorkspace

# unlink $0
