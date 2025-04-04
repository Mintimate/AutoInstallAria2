# .ide/Dockerfile
FROM debian:bookworm

# 安装 ssh 服务(用于支持 VSCode 客户端通过 Remote-SSH 访问开发环境);
RUN apt update && \
    apt install -y \
    wget \
    curl \
    git \
    unzip \
    openssh-server \
    vim \
    zsh \
    build-essential \
    webp \
    cmake && \
    chsh -s /bin/zsh && \
    yes | zsh -c "$(curl -fsSL 'https://cnb.cool/Mintimate/tool-forge/oh-my-zsh/-/git/raw/main/AutoInstallZshWithPlugin.sh')"

# 安装 code-server 和 vscode 常用插件
RUN curl -fsSL https://code-server.dev/install.sh | sh \
  && code-server --install-extension redhat.vscode-yaml \
  && code-server --install-extension dbaeumer.vscode-eslint \
  && code-server --install-extension eamodio.gitlens \
  && code-server --install-extension tencent-cloud.coding-copilot \
  && echo done

# 指定字符集支持命令行输入中文（根据需要选择字符集）
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
