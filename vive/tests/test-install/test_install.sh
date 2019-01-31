#!/usr/bin/env bash

# Author: John Sigmon

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: test_install.sh <-b|--branch branch containing modification to test> [-l|--logfile logfile]"
	exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b|--branch)
    BRANCH_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--logfile)
    LOGFILE="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

timestamp() {
      date +"%T"
}

MYFILENAME="test_install.sh"

# Check if log was passed in, if not then make one
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log_${MYFILENAME}_$(timestamp).txt"
fi

#unsure if --no-chache flag is needed in general, it forces image to build from scratch.
if ! docker build --branch_name "$BRANCH_NAME" --no-cache -t testinstall . 2>&1 | tee -a "$LOGFILE"

then
    echo "[ERROR l.$LINENO $MYFILENAME] Docker build failed." # to logfile or no?
    exit 1
fi

docker run -a STDOUT testinstall 2>&1 | tee -a "$LOGFILE"

#####################################################################
# Grep log for errors
#####################################################################
# -c for count, -e acts as switch statement
NUMERRORS=$(grep -c -e ERROR -e E. "$LOGFILE")
if [ "$NUMERRORS" = "0" ]
then
    echo "[ERROR: $0 $LINENO $(timestamp)] $NUMERRORS tests failed.]" 2>&1 | tee -a "$LOGFILE"
    exit 1
else
    echo "No errors found in log file."
    exit 0
fi
