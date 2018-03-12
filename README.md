# Runbook_8ch_NDI_encoder

Install and compile Ubuntu FFmpeg NDI-encoder machine.
-------------------------
Install Ubuntu 16.04 Desktop with username NDI, networkname "Machinename in NDI network", and autoboot enabled
Disable lockscreensaver

sudo apt-get install git

git clone https://github.com/tv2/Runbook_8ch_NDI_encoder.git ffmpeg_runbook

cd ffmpeg_runbook

edit the encodernames in encode8HDSDI.sh

Run script:

sudo chmod +X runbook.sh

./runbook.sh

Open desktopvideo (Decklink GUI) and setup card for 8 input.





--------------------------------------------------

FFmpeg examples:
----------------------

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


