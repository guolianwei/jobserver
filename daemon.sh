usage="Usage: daemon.sh (start|stop)"
sbin="`dirname "$0"`"
sbin="`cd "$sbin"; pwd`"
if [ "$XTKKX_ENETPCL_PID_DIR" = "" ]; then
  MERIT_DATA_CLOUD_ANALYSE_PID_DIR=/tmp
fi
if [ "$MERIT_DATA_CLOUD_ANALYSE_IDENT_STRING" = "" ]; then
  export MERIT_DATA_CLOUD_ANALYSE_IDENT_STRING="$USER"
fi

export HNAME_MERITDATA="$HOSTNAME"

#get log directory
if [ "$MERIT_DATA_CLOUD_ANALYSE_LOG_DIR" = "" ]; then
  export MERIT_DATA_CLOUD_ANALYSE_LOG_DIR="$sbin/jobserver-logs"
fi
export _XTKKX_ENETPCL_DAEMON_OUT=$MERIT_DATA_CLOUD_ANALYSE_LOG_DIR/jobserver-$MERIT_DATA_CLOUD_ANALYSE_IDENT_STRING-$HNAME_MERITDATA.log
export _MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE=$MERIT_DATA_CLOUD_ANALYSE_PID_DIR/jobserver-$MERIT_DATA_CLOUD_ANALYSE_IDENT_STRING.pid
echo log file is : $_XTKKX_ENETPCL_DAEMON_OUT
# if no args specified, show usage
if [ $# -lt 1 ]; then
  echo $usage
  exit 1
fi
# get arguments
startStop=$1
case $startStop in
  (start)
    mkdir -p "$MERIT_DATA_CLOUD_ANALYSE_PID_DIR"
    mkdir -p "$MERIT_DATA_CLOUD_ANALYSE_LOG_DIR"
    if [ -f $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE ]; then
      if kill -0 `cat $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE` > /dev/null 2>&1; then
        echo jobserver running as process `cat $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE`.  Stop it first.
        exit 1
      fi
    fi
    echo starting
    nohup python  "$sbin"/jobserver.py >> $_XTKKX_ENETPCL_DAEMON_OUT 2>&1  &
    echo $! > $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE
    echo jobserver started
    tailf $_XTKKX_ENETPCL_DAEMON_OUT
   ;;
  (stop)
    if [ -f $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE ]; then
      if kill -0 `cat $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE` > /dev/null 2>&1; then
        echo stopping jobserver
        kill `cat $_MERIT_DATA_CLOUD_ANALYSE_DAEMON_PIDFILE`
      else
        echo no jobserver to stop
      fi
    else
      echo no jobserver to stop
    fi
  ;;
  (*)
    echo $usage
    exit 1
    ;;

esac
