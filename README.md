# AutoInstallAria2
Auto Install Aria2 To Linux。
自动配置安装 Aria2 到 Linux 服务器或者 Linux 发行版里。

## 一键配置安装
```
 | bash
bash -c "$(wget -qO- https://cnb.cool/Mintimate/tool-forge/AutoInstallAria2/-/git/raw/main/AutoInstallAria2ForLinux.sh)"
```

![安装中](assets/startShell.webp)

![安装成功](assets/finishedShell.webp)

### 配置文件

一键安装后，默认在`$HOME/aria2Auto`下生成配置文件`aria2.conf`等文件:
```bash
mintimate at StarServer in ~/aria2Auto
$ tree
.
├── aria2c
├── aria2.conf
└── deleteAria2.conf
```

使用`systemctl`管理 Aria2 服务:

![aria2服务启动](assets/systemctlStatus.webp)

## Docker 部署

当前支持 ARM64 和 AMD64 架构的 Docker 包:
```bash
docker run -d -p 6800:6800 -v ~/Downloads:/app/Downloads docker.cnb.cool/mintimate/tool-forge/autoinstallaria2
```
其中:
- `-p 6800:6800`：将容器内的 6800 端口映射到宿主机的 6800 端口;
- `-v ~/Downloads:/app/Downloads`：将宿主机上的`~/Downloads`目录映射到容器内的`/app/Downloads`目录。

RPC 初始密码获取:
```bash
docker exec -it 38c0a4e3374f cat /app/initAria2Password
```

## 卸载
如果需要卸载该脚本所安装的一切 Aria2，只需要：
```bash
rm -rf $HOME/aria2Auto
systemctl --user disable aria2
systemctl --user stop aria2
rm -rf ~/.config/systemd/user/aria2.service
```

删除后，无其他残留文件。

## Licence

[![GPLv3](gplv3.png)](LICENSE)