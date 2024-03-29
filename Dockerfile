FROM debian:bullseye

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i it_IT -c -f UTF-8 -A /usr/share/locale/locale.alias it_IT.UTF-8
ENV LANG it_IT.utf8

ENV DEBIAN_FRONTEND noninteractive

ENV BUILD_DEPS="git patch make libgtk2.0-0 build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev"

RUN apt -y update && apt -y full-upgrade && apt -yy install apt-utils software-properties-common $BUILD_DEPS

RUN apt -y update && apt -y install --no-install-recommends xfce4

RUN apt -y update && apt -y install \
  nano \
  openssh-server \
  xrdp \
  dbus-x11 \
  supervisor \
  aria2 \
  wget \
  curl \ 
  mpv \
  trash-cli \
  mediainfo \
  mediainfo-gui \
  amule \
  firefox-esr \
  filezilla \
  xfce4-terminal \
  xarchiver \
  mousepad \
  htop \
  ffmpeg \
  python3-pip \
  sudo \
  mkvtoolnix \
  mkvtoolnix-gui \
  rename

# Youtube-DLP

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
  chmod a+rx /usr/local/bin/yt-dlp

# MNAMER & PySubs2

RUN pip3 install mnamer pysubs2

# Filebot

WORKDIR /tmp
RUN wget https://get.filebot.net/filebot/FileBot_4.9.6/FileBot_4.9.6_amd64.deb && \
  apt install -y ./FileBot_4.9.6_amd64.deb

# RenameMyTVSeries

WORKDIR /tmp
RUN wget https://www.tweaking4all.com/downloads/betas/RenameMyTVSeries-2.1.7-GTK-beta-Linux-64bit-shared-ffmpeg.tar.gz && \
  mkdir /usr/share/RenameMyTVSeries && \
  tar -zxvf RenameMyTVSeries-2.1.7-GTK-beta-Linux-64bit-shared-ffmpeg.tar.gz -C /usr/share/RenameMyTVSeries

# MakeMKV

WORKDIR /tmp
RUN wget https://www.makemkv.com/download/makemkv-bin-1.17.2.tar.gz && \
  wget https://www.makemkv.com/download/makemkv-oss-1.17.2.tar.gz && \
  tar -xvf makemkv-bin-1.17.2.tar.gz && \
  tar -xvf makemkv-oss-1.17.2.tar.gz && \
  cd ./makemkv-oss-1.17.2 && \
  ./configure && \
  make && \
  make install && \
  cd ../makemkv-bin-1.17.2 && \
  mkdir -p "tmp" && \
  echo "accepted" >> "tmp/eula_accepted" && \
  make && \
  make install

# Post-install configuration

RUN rm -r /tmp/*

ADD ./miscs/ect/ /etc

COPY ./miscs/run.sh /

RUN chmod +x /run.sh

RUN ssh-keygen -A

EXPOSE 3389 22

ENTRYPOINT ["/run.sh"]

