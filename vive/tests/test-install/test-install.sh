#!/usr/bin/env bash

# Author: John Sigmon

# Last Modified: 12-11-2018

#####################################################################
# Parse args
#####################################################################
#if [ $# -lt 2 ];
#then
#	echo "Usage: single_node_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
#	exit 1
#fi
#
#while [[ $# -gt 0 ]]
#do
#key="$1"
#
#case $key in
#    -c|--catkin)
#    CATKIN_RELATIVE=${2%/} # strip trailing slash
#    shift # past argument
#    shift # past value
#    ;;
#    -l|--logfile)
#    LOGFILE="$2"
#    shift # past argument
#    shift # past value
#    ;;
#esac
#done

timestamp() {
      date +"%T"
}

MYFILENAME="test_install.sh"
#LOGFILE="log_${MYFILENAME}_$(timestamp).txt"
#LOGDIR="logs"

# start time

#unsure if --no-chache flag is needed?
if ! docker build --no-cache -t testinstall .
then
    echo "[ERROR l.$LINENO $MYFILENAME] Docker needs to be installed." # to logfile or no?
    exit 1
fi

docker run -a STDOUT testinstall > "$LOGFILE" 

#NUM_ERRORS=$(grep $LOGFILE E | wc -l)
#if 
# search for errors 
# copy code from test-singlenode launch

# write out results

# grab end time

# move both files
