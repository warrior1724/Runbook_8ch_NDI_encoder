#!/bin/sh

#This script will prepare - compile and install an 8-channel Decklink-NDI encoder

#Environment:
InstallDir=.

#Cleanup Ubuntu:
sudo apt-get purge account-plugin-aim account-plugin-facebook account-plugin-flickr account-plugin-jabber account-plugin-salut account-plugin-yahoo aisleriot gnome-mahjongg gnome-mines gnome-sudoku unity-lens-photos unity-lens-video unity-scope-audacious unity-scope-chromiumbookmarks unity-scope-clementine unity-scope-colourlovers unity-scope-devhelp unity-scope-firefoxbookmarks unity-scope-gmusicbrowser unity-scope-gourmet unity-scope-musique unity-scope-openclipart unity-scope-texdoc unity-scope-tomboy unity-scope-video-remote unity-scope-zotero unity-webapps-common libreoffice*  thunderbird* rhythm*


#Resize Ubuntu network system buffer: 
#(to avoid h264 blur and other network related problems)
sudo sysctl -w net.core.rmem_max=8388608
sudo sysctl -w net.core.wmem_max=8388608
sudo sysctl -w net.core.rmem_default=65536
sudo sysctl -w net.core.wmem_default=65536
sudo sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608'
sudo sysctl -w net.ipv4.tcp_wmem='4096 65536 8388608'
sudo sysctl -w net.ipv4.tcp_mem='8388608 8388608 8388608'
sudo sysctl -w net.ipv4.route.flush=1

#Dependencies for FFmpeg:
sudo apt-get update -qq
sudo apt-get -y install autoconf automake build-essential cmake git libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev mercurial pkg-config  texinfo  wget  zlib1g-dev yasm libx264-dev libx265-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev 

#NDI SDK:
cd $InstallDir
sudo chmod +x InstallNDISDK_v3_Linux.sh
sudo ./InstallNDISDK_v3_Linux.sh

#Copy files from NDI SDK:
mkdir ~/ffmpeg_sources
mkdir ~/ffmpeg_sources/ndi
cd ~/ffmpeg_sources/ndi
cp -r "$InstallDir/NDI\ SDK\ for\ Linux/include" .
cp -r "$InstallDir/NDI\ SDK\ for\ Linux/lib/x86_64-linux-gnu" ./lib
cd $HOME

#Copy NDI configfile: 
sudo cp $InstallDir/ndi.conf /etc/ld.so.conf.d/ndi.conf

#Activate configuration:
sudo ldconfig

#Decklink SDK:
mkdir $HOME/DecklinkSDK
cp -R $InstallDir/Linux $HOME/DecklinkSDK

#Get FFmpeg:
cd $HOME
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

#Compile:
mkdir $HOME/ffmpeg_build
mkdir $HOME/ffmpeg_build/lib 
mkdir $HOME/ffmpeg_build/lib/pkgconfig
PATH=$HOME/bin:$PATH
PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig
cd $HOME/ffmpeg
sudo ./configure  --prefix=$HOME/ffmpeg_build  --pkg-config-flags=--static  --extra-cflags=-I$HOME/ffmpeg_sources/ndi/include  --extra-ldflags=-L$HOME/ffmpeg_sources/ndi/lib  --bindir=$HOME/bin --enable-ffplay --enable-gpl  --enable-libass  --enable-libfdk-aac  --enable-libfreetype  --enable-libmp3lame  --enable-libopencore-amrnb   --enable-libopencore-amrwb  --enable-librtmp   --enable-libopus   --enable-libtheora   --enable-libvorbis   --enable-libvpx   --enable-libx264 --enable-nonfree   --enable-version3 --enable-libndi_newtek --enable-decklink --extra-cflags=-I$HOME/DecklinkSDK/Linux/include

make
make install

#Load Encoderscript at startup:
sudo chmod +X HDSDItoNDI.sh
sudo chmod +X encode8HDSDI.sh
sudo cp $InstallDir/encode8HDSDI.sh.desktop ~/.config/autostart/encode8HDSDI.sh.desktop



