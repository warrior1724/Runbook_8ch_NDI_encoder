# Runbook_8ch_NDI_encoder

Install and compile Ubuntu FFmpeg NDI-encoder machine.

Install Ubuntu 16.04 Desktop with username NDI:
git clone /xxxxxxx ffmpeg_runbook

edit the encodernames in encode8HDSDI.sh

Run sripct:
sudo chmod +X runbook.sh
./runbook.sh





--------------------------------------------------

Based on these skecthes:
Ubuntu:

Clean up:

sudo apt-get purge account-plugin-aim account-plugin-facebook account-plugin-flickr account-plugin-jabber account-plugin-salut account-plugin-yahoo aisleriot gnome-mahjongg gnome-mines gnome-sudoku unity-lens-photos unity-lens-video unity-scope-audacious unity-scope-chromiumbookmarks unity-scope-clementine unity-scope-colourlovers unity-scope-devhelp unity-scope-firefoxbookmarks unity-scope-gmusicbrowser unity-scope-gourmet unity-scope-musique unity-scope-openclipart unity-scope-texdoc unity-scope-tomboy unity-scope-video-remote unity-scope-zotero unity-webapps-common libreoffice*  thunderbird* rhythm*



Installer TeamWiever:

Download, gem og kør.

sudo apt-get install -f ./teamviewer_13.0.9865_amd64.deb



Kør ubuntu med skærm slukket:

For at aktivere GPU skal der sidde skærm på en Linux maskine (kan omgås med en simples KVM alá G&D)



Resize Ubuntu network system buffer: (to avoid h264 blur and other network related problems)

https://wwwx.cs.unc.edu/~sparkst/howto/network_tuning.php



sudo sysctl -w net.core.rmem_max=8388608

sudo sysctl -w net.core.wmem_max=8388608

sudo sysctl -w net.core.rmem_default=65536

sudo sysctl -w net.core.wmem_default=65536

sudo sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608'

sudo sysctl -w net.ipv4.tcp_wmem='4096 65536 8388608'

sudo sysctl -w net.ipv4.tcp_mem='8388608 8388608 8388608'

sudo sysctl -w net.ipv4.route.flush=1

FFmpeg:



https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu



Dependencies:

1: sudo apt-get update -qq

2: sudo apt-get -y install autoconf automake build-essential cmake git libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev mercurial pkg-config  texinfo  wget  zlib1g-dev yasm libx264-dev libx265-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev 

3: FFMPEG med x11 styring: sudo apt-get install libsdl2-dev libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev







NDI del:

Find SDK pak ud:

sudo chmod +x InstallNDISDK_v3_Linux.sh

sudo ./InstallNDISDK_v3_Linux.sh





kopier det til ffmpeg_sources:

mkdir ~/ffmpeg_sources

mkdir ~/ffmpeg_sources/ndi

cd ~/ffmpeg_sources/ndi

cp -r ~/Downloads/NDI\ SDK\ for\ Linux/include .

cp -r ~/Downloads/NDI\ SDK\ for\ Linux/lib/x86_64-linux-gnu ./lib

(Efter denne opskrift: https://github.com/mltframework/mlt/issues/215)



Sti til bibliotek skal skrive i denne fil: 

sudo nano /etc/ld.so.conf.d/ndi.conf

/home/{YOUR USERNAME}/ffmpeg_sources/ndi/lib

Aktiver konfiguration:

sudo ldconfig


Decklink:

Download Blackmagic desktop Video (GUI konfiguration af kort)

Download Decklink SDK

Mkdir og Kopier til DecklinkSDK (cp -R Linux $HOME/DecklinkSDK)



cd ~

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg



cd ffmpeg

Optional:

(sudo nano ./configure

Enable ffplay og probe)



Compiler FFMPEG:

mkdir $HOME/ffmpeg_build

mkdir $HOME/ffmpeg_build/lib 

mkdir $HOME/ffmpeg_build/lib/pkgconfig

1: PATH=$HOME/bin:$PATH

2: PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig

3: cd $HOME/ffmpeg

4:

sudo ./configure  --prefix=$HOME/ffmpeg_build  --pkg-config-flags=--static  --extra-cflags=-I$HOME/ffmpeg_sources/ndi/include  --extra-ldflags=-L$HOME/ffmpeg_sources/ndi/lib  --bindir=$HOME/bin --enable-ffplay --enable-gpl  --enable-libass  --enable-libfdk-aac  --enable-libfreetype  --enable-libmp3lame  --enable-libopencore-amrnb   --enable-libopencore-amrwb  --enable-librtmp   --enable-libopus   --enable-libtheora   --enable-libvorbis   --enable-libvpx   --enable-libx264 --enable-nonfree   --enable-version3 --enable-libndi_newtek --enable-decklink --extra-cflags=-I$HOME/DecklinkSDK/Linux/include


5: make

6: make install



Tjek at "avahi-daemon installed"



Startup script:

runffmpeg folder har 2 scripts

HDSDItoNDI.sh Script -restart service:

while true; do

        ffmpeg -err_detect explode -f decklink -i 'DeckLink Quad ('$1')' -f libndi_newtek '$

        echo "Input ""$1"" crashed: returncode §?" >&2

        sleep 2

done


encode8HDSDI.sh Script Loader:

xterm -T "Encoder 1" -geometry 70x30+1+1 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 1 &

xterm -T "Encoder 2" -geometry 70x30+500+1 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 2 &

xterm -T "Encoder 3" -geometry 70x30+1000+1 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 3 &

xterm -T "Encoder 4" -geometry 70x30+1500+1 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 4 &

xterm -T "Encoder 5" -geometry 70x30+1+550 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 5 &

xterm -T "Encoder 6" -geometry 70x30+500+550 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 6 &

xterm -T "Encoder 7" -geometry 70x30+1000+550 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 7 &

xterm -T "Encoder 8" -geometry 70x30+1500+550 -e /home/ndi/runffmpeg/HDSDItoNDI.sh 8 &



Start script at boot:

Tilføj encode8HDSDI.sh til “startup application” gui program. 







Test stream: 

Direct RTSP URL:

* rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov

Direct HTTP URL to sample file:

* http://www.wowza.com/_h264/BigBuckBunny_115k.mov


NewTek NDI streams:

* ffmpeg -f libndi_newtek -find_sources 1 -i dummy

* ffmpeg -f libndi_newtek -i 'CONNECT02 (TV2 Sport HD)' -f libndi_newtek “FFmpegNDI01”

Ud af DeckLink:

* 720p50:

    * ffmpeg -r 50 -f libndi_newtek -i 'NDI-HP-ELITEDESK-800-G3-TWR (KAOLtest01)' -buffer_size 1500M -an -f decklink 'DeckLink Quad (8)’

* 1080i:

    * ffmpeg -f libndi_newtek -i 'CONNECT02 (Afv.G)' -buffer_size 3000M -an -f decklink -s 1920x1080 -r 25000/1000 'DeckLink Quad (8)'

Decklink encoder:

* ffmpeg -f decklink -i 'DeckLink Quad (1)' -f libndi_newtek 'HD-SDI01'



Output UDP strøm:

* ffmpeg -r 50 -i "udp://232.101.1.7:5500" -f libndi_newtek -pix_fmt uyvy422 -clock_video true KAOL_RTP_01



* (Stutters: ffmpeg -i “rtp://@232.101.1.3:5500?fifo_size=1000000&amp;overrun_nonfatal=1" -pix_fmt uyvy422 -f libndi_newtek “RTPFFmpegNDI02")
