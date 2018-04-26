#!/bin/sh
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run -u chrome \
    --volume="`pwd`:/home/chrome/data-dir" \
    --volume=$XSOCK:$XSOCK:rw \
    --device=/dev/dri:/dev/dri \
    --device=/dev/video0:/dev/video0 \
    -v /run/user/$UID/pulse/native:/home/chrome/pulse \
    --env="PULSE_SERVER=unix:/home/chrome/pulse" \
    -v /run/dbus/:/run/dbus/ \
    -v /dev/shm:/dev/shm \
    --volume=$XAUTH:$XAUTH:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY" \
    --entrypoint="/usr/bin/chromium-browser" \
    chrome \
    --user-data-dir=/home/chrome/data-dir --no-sandbox --window-position=0,0 --window-size=1024,768 --force-device-scale-factor=1 \
    --enable-gpu-rasterization --ignore-gpu-blacklist \
    https://www.google.de/search?q=webcam-test

    #--enable-gpu-rasterization --ignore-gpu-blacklist 

rm -f $XAUTH
