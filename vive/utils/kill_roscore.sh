PID=$(ps | awk '/roscore/ {print $1}')
kill "$PID"
