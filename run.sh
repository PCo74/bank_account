#! /usr/bin/env bash

# osascript -e 'tell application "Terminal" to set visible of front window to false'
osascript -e 'tell application "Terminal" to set visible of front window to true'
PORT=$((8000 + 80))
echo "PORT : $PORT"

while ! curl http://localhost:$PORT -s -f -o /dev/null; do
  sleep 0.2
done && open http://localhost:$PORT &

# mkdocs serve -a localhost:$PORT > /dev/null
sqlpage
