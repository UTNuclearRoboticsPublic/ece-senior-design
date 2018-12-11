#!/usr/bin/env bash
#
# Author: John Sigmon 


# Add cline args later

timestamp() {
      date +"%T"
}

MYFILENAME="$0"
SCRIPTDIR="$(dirname "$MYFILENAME")"
CATKINNAME="test-catkin"
CATKINPATH="$SCRIPTDIR"/"$CATKINNAME"
LOGFILE="log$(timestamp)$MYFILENAME.txt"
cd "$SCRIPTDIR" || exit 1 >> "$PWD"/"$LOGFILE"

# Make sure test-catkin is there
if [ ! -d "$CATKINPATH" ];
then
    ERROR="[ERROR: $0 $LINENO $(timestamp)] There must be a catkin workspace installed inside tests/ called test-catkin. Exiting now..."
    echo "$ERROR"
    echo "$ERROR" >> "$LOGFILE"
    exit 1
fi

#####################################################################
# Run single node launch (vanilla, TODO name tests later)
#####################################################################
if ! bash ../single_node_launch.sh -c "$CATKINPATH" -l "$LOGFILE"
then
    # We want to log an error with the testname, as we make test names
    echo "[ERROR: $0 $LINENO $(timestamp)] First test failed.]" >> "$LOGFILE"
else
    echo "[INFO: $0 $LINENO $(timestamp)] First test passed!]" >> "$LOGFILE"
fi


#####################################################################
# Grep log for errors
#####################################################################
NUMERRORS=$(grep ERROR "$LOGFILE")
if [ "$NUMERRORS" = "0" ]
then
    echo "[ERROR: $0 $LINENO $(timestamp)] $NUMERRORS tests failed.]" >> "$LOGFILE"
    exit 1
else
    echo "[ERROR: $0 $LINENO $(timestamp)] $NUMERRORS tests failed.]" >> "$LOGFILE"
    exit 0
fi

#TODO fail on warnings?

