::# SPDX-License-Identifier: Apache-2.0
::# Copyright (c) 2020 Intel Corporation

set vlc_path="c:\Program Files (x86)\VideoLAN\VLC"
set file_name="c:\Data\Safety_Full_Hat_and_Vest.avi"
set port="8554"

echo  "kill if any VLC process running"
taskkill /F /IM vlc.exe
timeout 5

echo  "Start vlc rtsp stream"
cd %vlc_path%

vlc.exe %file_name% --sout=#gather:rtp{sdp=rtsp://0.0.0.0:%port%/} --loop --sout-keep
