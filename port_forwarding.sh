#!/usr/bin/env bash
#
# Enable port forwarding when using Private Internet Access
#
# Usage:
#  ./port_forwarding.sh

TRANSUSER=transmissionuser
TRANSPASS=transmissionpassword
TRANSHOST=127.0.0.1

error( )
{
  echo "$@" 1>&2
  exit 1
}

error_and_usage( )
{
  echo "$@" 1>&2
  usage_and_exit 1
}

usage( )
{
  echo "Usage: `dirname $0`/$PROGRAM"
}

usage_and_exit( )
{
  usage
  exit $1
}

version( )
{
  echo "$PROGRAM version $VERSION"
}


port_forward_assignment( )
{
  echo 'Loading port forward assignment information...'
  if [ "$(uname)" == "Linux" ]; then
    client_id=`head -n 100 /dev/urandom | sha256sum | tr -d " -"`
  fi
  if [ "$(uname)" == "Darwin" ]; then
    client_id=`head -n 100 /dev/urandom | shasum -a 256 | tr -d " -"`
  fi

  PORT=`curl "http://209.222.18.222:2000/?client_id=$client_id" | jq -r '.port'`
  if [ "$PORT" == "" ]; then
    json='Port forwarding is already activated on this connection, has expired, or you are not connected to a PIA region that supports port forwarding'
  fi
  
  echo $PORT
  
  change_trans_port $PORT
}

change_trans_port( )
{
  if [ -z "$1" ]                           # Was a parameter poassed?
  then
    echo "Please supply a port number to this function"  # :|
	exit 1
  fi
  
  CURLOUT=$(curl -u $TRANSUSER:$TRANSPASS ${TRANSHOST}:9091/transmission/rpc 2>/dev/null)
  REGEX='X-Transmission-Session-Id\: (\w*)'

  if [[ $CURLOUT =~ $REGEX ]]; then
    SESSIONID=${BASH_REMATCH[1]}
  else
    exit 1
  fi

  DATA='{"method": "session-set", "arguments": { "peer-port" :'$PORT' } }'

  curl -u $TRANSUSER:$TRANSPASS http://${TRANSHOST}:9091/transmission/rpc -d "$DATA" -H "X-Transmission-Session-Id: $SESSIONID"

}

EXITCODE=0
PROGRAM=`basename $0`
VERSION=2.1

while test $# -gt 0
do
  case $1 in
  --usage | --help | -h )
    usage_and_exit 0
    ;;
  --version | -v )
    version
    exit 0
    ;;
  *)
    error_and_usage "Unrecognized option: $1"
    ;;
  esac
  shift
done

port_forward_assignment

exit 0



