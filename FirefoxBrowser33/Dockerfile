FROM index.alauda.cn/fanlin/browser-base:latest
MAINTAINER FanLin <linfan.china@gmail.com>

# 使用 Root 用户
USER root

# 官方的 deb 包没有依赖信息，因此首先安装 ubuntu ppa 的 deb 包用于安装环境依赖，这只是一个变通的方案
RUN mkdir /pkg
RUN BASE_DEB="http://security.ubuntu.com/ubuntu/pool/main/f/firefox/firefox_33.0+build2-0ubuntu0.14.10.1_amd64.deb"; \
  wget -O /pkg/base.deb ${BASE_DEB} \
  && apt-get update -qqy \
  && dpkg -i /pkg/base.deb; \
  apt-get install --yes --fix-broken \
  && apt-get upgrade --yes \
  && rm -rf /var/lib/apt/lists/* \
  && rm /pkg/base.deb

# 安装 Firefox
RUN FIREFOX_DEB="http://sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build/firefox-mozilla-build_33.1.1-0ubuntu1_amd64.deb/download"; \
  wget -O /pkg/firefox.deb ${FIREFOX_DEB} \
  && dpkg -i /pkg/firefox.deb \
  && rm /pkg/firefox.deb



# 拷贝启动脚本
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

CMD ["/opt/bin/entry_point.sh"]
