#!/bin/bash
set -e

echo 'Starting jupyter w/ kedro on http://localhost:8888'
screen -dmS jupyter kedro jupyter notebook --allow-root  --ip 0.0.0.0 --no-browser

echo 'Starting kedro-viz on http://localhost:4141'
screen -dmS kedro-viz kedro viz --host 0.0.0.0 --no-browser

exec /bin/bash