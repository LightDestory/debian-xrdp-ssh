FROM debian:testing

ENV LANG C.UTF-8

ENV DEBIAN_FRONTEND noninteractive

ENV BUILD_DEPS="git patch make libgtk2.0-0 build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev"

RUN apt -y update && apt -y full-upgrade && apt -yy install apt-utils software-properties-common $BUILD_DEPS

RUN apt -y install --no-install-recommends xfce4

RUN apt -y install \
  nano \
  openssh-server \
  xrdp \
  dbus-x11 \
  supervisor \
  aria2 \
  wget \
  curl \ 
  vlc \
  trash-cli \
  mediainfo \
  mediainfo-gui \
  amule \
  fish \ 
  firefox-esr \
  filezilla \
  xfce4-terminal \
  unrar-free \
  xarchiver \
  mousepad \
  htop \
  ffmpeg \
  python3-pip \
  sudo \
  mkvtoolnix \
  mkvtoolnix-gui

# Youtube-DLP

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
  chmod a+rx /usr/local/bin/yt-dlp

# ADMVCP

WORKDIR /tmp

RUN FORCE_UNSAFE_CONFIGURE=1 && export FORCE_UNSAFE_CONFIGURE && curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh && (cd advcpmv && sh install.sh)

RUN mv ./advcpmv/advcp /usr/local/bin/cpg && mv ./advcpmv/advmv /usr/local/bin/mvg

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
RUN wget https://www.makemkv.com/download/makemkv-bin-1.17.0.tar.gz && \
  wget https://www.makemkv.com/download/makemkv-oss-1.17.0.tar.gz && \
  tar -xvf makemkv-bin-1.17.0.tar.gz && \
  tar -xvf makemkv-oss-1.17.0.tar.gz && \
  cd ./makemkv-oss-1.17.0 && \
  ./configure && \
  make && \
  make install && \
  cd ../makemkv-bin-1.17.0 && \
  mkdir -p "tmp" && \
  echo "accepted" >> "tmp/eula_accepted" && \
  make && \
  make install

# Fix for VLC as root

RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc 

# Post-install configuration

RUN rm -r /tmp/*

ADD ./miscs/ect/ /etc

COPY ./miscs/run.sh /

RUN chmod +x /run.sh

RUN ssh-keygen -A

EXPOSE 3389 22

ENTRYPOINT ["/run.sh"]

