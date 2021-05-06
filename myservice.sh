#!/bin/sh

USER="zyxt"
PIDFILE="/var/run/myservice.pid"

get_id() {
    cat "$PIDFILE"
}

is_up() {
    [ -f "$PIDFILE" ] && ps -p `get_pid` > /dev/null 2>&1
}

start() {
    if is_up; then
        echo "Already running"
    else 
        echo "Starting myservice..."
        if [ -z "$USER" ]; then
            sudo myservice &
        else
            sudo -u "$USER" myservice &
        fi
        echo $! > "$PIDFILE"
    fi
}

stop() {
    if is_up; then
        echo -n "Stopping myservice..."
        kill `get_pid`
        for i in 1 2 3 4 5 6 7 8 9 10
        do
            if ! is_up; then
                break
            fi

            echo -n "."
            sleep 1
        done
        echo

        if is_up; then 
            echo "Not stopped! May still be shutting down or may have failed!"
            exit 1
        else
            echo "Stopped"
            if [ -f "$PIDFILE" ]; then
                rm "$PIDFILE"
            fi
        fi
    else
        echo "Not running"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
exit 0