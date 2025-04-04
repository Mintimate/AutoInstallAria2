# 使用最小的 Debian 镜像作为基础
FROM debian:bookworm-slim

# 设置环境变量 ROOT_PATH
ENV ROOT_PATH=/app
ENV DOWNLOAD_PATH=/app/Downloads
ENV AutoSetPassword=true

# 更新包列表并安装 wget
RUN apt update && \
    apt install -y wget && \
    rm -rf /var/lib/apt/lists/*

# 工作目录
RUN mkdir -p ${ROOT_PATH}
WORKDIR ${ROOT_PATH}
COPY AutoInstallAria2ForLinux.sh .

RUN chmod +x AutoInstallAria2ForLinux.sh && \
    bash AutoInstallAria2ForLinux.sh

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 暴露端口
EXPOSE 6800 51413

# 启动时候的脚本（用于重置密码）
ENTRYPOINT ["/app/entrypoint.sh"]
# 设置容器启动时运行的命令
CMD ["/app/aria2c", "--conf-path=/app/aria2.conf"]