FROM index.alauda.cn/fanlin/browser-base:latest
MAINTAINER FanLin <linfan.china@gmail.com>

# 使用 Root 用户
USER root

# 安装 Chrome
RUN mkdir /pkg
RUN  BROWSER_DEB="http://google-chrome.en.uptodown.com/ubuntu/download/105795"; \
     wget -O /pkg/download_page ${BROWSER_DEB}; \
     DEB_URL=$(cat /pkg/download_page | grep 'http-equiv="refresh"' | sed 's#^.* url=\([^"]*\)".*$#\1#g'); \
     wget -O /pkg/google-chrome.deb ${DEB_URL}; \
     rm /pkg/download_page
RUN apt-get update -qqy \
  && dpkg -i /pkg/google-chrome.deb; apt-get --yes --fix-broken install \
  && rm -rf /var/lib/apt/lists/* \
  && rm /pkg/google-chrome.deb

RUN wget http://kr.archive.ubuntu.com/ubuntu/pool/main/u/udev/libudev0_175-0ubuntu9_amd64.deb -O /pkg/libudev0.deb %EXTRA_COMMAND%%EXTRA_COMMAND% dpkg -i /pkg/libudev0.deb

# 拷贝启动脚本
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

CMD ["/opt/bin/entry_point.sh"]
