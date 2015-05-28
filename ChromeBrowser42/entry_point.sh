#!/bin/bash
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}
trap shutdown SIGTERM SIGINT

sudo -E -i -u alauda \
  DISPLAY=$DISPLAY \
  xvfb-run --server-args="$DISPLAY -screen 0 $GEOMETRY -ac +extension RANDR" \
  /opt/google/chrome/chrome alauda.cn &
NODE_PID=$!

for i in $(seq 1 10); do
  xdpyinfo -display $DISPLAY >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    break
  fi
  echo Waiting xvfb...
  sleep 0.5
done

fluxbox -display $DISPLAY &

x11vnc -forever -usepw -shared -rfbport 5900 -display $DISPLAY &

wait $NODE_PID
