FROM ubuntu:14.04
MAINTAINER FanLin <linfan.china@gmail.com>

# 使用root用户
USER root

# 删除多余apt-get源
RUN  echo "deb http://archive.ubuntu.com/ubuntu trusty main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe\n" >> /etc/apt/sources.list

# 更新源
RUN apt-get update -qqy

# 安装基本依赖
RUN apt-get -qqy --no-install-recommends install wget

# 安装 VNC、Xvfb 和 Fluxbox
RUN apt-get -qqy install x11vnc xvfb fluxbox \
  && mkdir -p ~/.vnc \
  && x11vnc -storepasswd alauda ~/.vnc/passwd

# 配置语言
ENV LANGUAGE zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
RUN /usr/share/locales/install-language-pack zh_CN \
  && locale-gen zh_CN.UTF-8 \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get -qqy --no-install-recommends install language-pack-zh-hans

# 安装字体
RUN apt-get -qqy --no-install-recommends install \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable

# 删除apt-get包列表
RUN rm -rf /var/lib/apt/lists/*

# 添加具有免密码sudo权限的普通用用户
RUN useradd alauda --shell /bin/bash --create-home \
  && usermod -a -G sudo alauda \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'alauda:alauda' | chpasswd

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# 设置时区
ENV TZ "PRC"
RUN echo "Asia/Shanghai" | tee /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

# 设置VNC的环境变量
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0

# 暴露VNC的端口
EXPOSE 5900

