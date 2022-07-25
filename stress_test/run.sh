#setup
cd /root
nvpmodel -m8
jetson_clocks
apt-get install stress

git clone  https://github.com/anseeto/jetson-gpu-burn
cd jetson-gpu-burn
make -j6

#cpu + gpu + Hw encoding
stress --cpu 6 & ./gpu_burn 100000 & gst-launch-1.0 -v videotestsrc pattern=smpte75 ! "video/x-raw, format=I420, width=3840, height=2160, framerate=25/1" ! nvvidconv ! "video/x-raw(memory:NVMM)" ! nvvidconv ! nvv4l2h264enc ! h264parse ! mux. audiotestsrc wave=silence freq=200 ! voaacenc ! aacparse ! queue ! mux. mpegtsmux name=mux ! hlssink max-files=2 playlist-length=2 target-duration=2 playlist-location=/root/playlist.m3u8 location=/root/playlist%d.ts & tegrastats


