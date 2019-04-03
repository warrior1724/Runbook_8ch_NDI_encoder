#!/bin/sh

# This script will prepare - compile and install an 8-channel Decklink-NDI encoder

# Environment:
InstallDir=$PWD

# Check if Username is correct (NDI in capital letters)
if [ "$(whoami)" != "NDI" ]; then
        echo "Script must be run as user: NDI"
        exit -1
fi


# Update Ubuntu:
echo "Updating Ubuntu"

sudo apt-get update
sudo apt-get -y upgrade

# Resize Ubuntu network system buffer: 
# (to avoid h264 blur and other network related problems)
echo "Resize Ubuntu network system buffer"

sudo sysctl -w net.core.rmem_max=8388608
sudo sysctl -w net.core.wmem_max=8388608
sudo sysctl -w net.core.rmem_default=65536
sudo sysctl -w net.core.wmem_default=65536
sudo sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608'
sudo sysctl -w net.ipv4.tcp_wmem='4096 65536 8388608'
sudo sysctl -w net.ipv4.tcp_mem='8388608 8388608 8388608'
sudo sysctl -w net.ipv4.route.flush=1

# Dependencies for FFmpeg:
echo "Dependencies for FFmpeg"
sudo apt-get -y install autoconf automake build-essential cmake git libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev mercurial pkg-config texinfo wget zlib1g-dev yasm libx264-dev libx265-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev 

# NDI SDK:
echo "NDI SDK"

cd $InstallDir/NDI-SDK
sudo chmod +x InstallNDISDK_v3_Linux.sh
sudo ./InstallNDISDK_v3_Linux.sh

# Move files from NDI SDK:
mkdir ~/ffmpeg_sources
mkdir ~/ffmpeg_sources/ndi
cd ~/ffmpeg_sources/ndi
mv  "$InstallDir/NDI-SDK/NDI SDK for Linux/include" .
mv  "$InstallDir/NDI-SDK/NDI SDK for Linux/lib/x86_64-linux-gnu" ./lib
cd $HOME

# Move and activate NDI configfile: 
echo "Move and activate NDI configfile"

sudo mv $InstallDir/NDI-SDK/NDI.conf /etc/ld.so.conf.d/NDI.conf
sudo ldconfig

# Install haivision/srt:
cd ~
git clone https://github.com/Haivision/srt.git
cd srt
./configure
make
sudo make install

#Get FFmpeg:
echo "Get FFmpeg"

cd $HOME
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

#Compile:
echo "Compile FFmpeg"

mkdir $HOME/ffmpeg_build
mkdir $HOME/ffmpeg_build/lib 
mkdir $HOME/ffmpeg_build/lib/pkgconfig
PATH=$HOME/bin:$PATH
PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig
cd $HOME/ffmpeg
./configure  --prefix=$HOME/ffmpeg_build  --pkg-config-flags=--static  --extra-cflags=-I$HOME/ffmpeg_sources/ndi/include  --extra-ldflags=-L$HOME/ffmpeg_sources/ndi/lib  --bindir=$HOME/bin --enable-ffplay --enable-gpl  --enable-libass  --enable-libfdk-aac  --enable-libfreetype  --enable-libmp3lame  --enable-libopencore-amrnb   --enable-libopencore-amrwb  --enable-librtmp   --enable-libopus   --enable-libtheora   --enable-libvorbis   --enable-libvpx   --enable-libx264 --enable-nonfree   --enable-version3 --enable-libndi_newtek --enable-decklink --extra-cflags=-I$HOME/DecklinkSDK/Linux/include --enable-libsrt

make
sudo make install

#Move Startupscripts to folder:
echo "Move startupscripts"

mkdir $HOME/runffmpeg
mv $InstallDir/StartUpScripts/encode8HDSDI.sh $HOME/runffmpeg/encode8HDSDI.sh
mv $InstallDir/StartUpScripts/HDSDItoNDI.sh $HOME/runffmpeg/HDSDItoNDI.sh

#Load Encoderscript at startup:
echo "Set Encoderscript at startup"

chmod +x $HOME/runffmpeg/HDSDItoNDI.sh
chmod +x $HOME/runffmpegencode8HDSDI.sh
mkdir ~/.config/autostart
mv $InstallDir/StartUpScripts/encode8HDSDI.sh.desktop ~/.config/autostart/encode8HDSDI.sh.desktop

#Finished:
echo "-------------------------------------------------------------"
echo
echo "Install Decklink GUI - desktopvideo"
echo "Manually set Decklink card for 8 inputs in Desktopvideo"
echo "And Reboot"
