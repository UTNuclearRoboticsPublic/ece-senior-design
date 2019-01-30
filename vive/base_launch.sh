#!/usr/bin/env bash
#####################################################################
# Purpose:       Launch base station part of the system including 
#                rviz, textured sphere, network, and VR plugin
# Authors:       Kate Baumli, Daniel Diamont, Caleb Johnson
# Last modified: 01/20/2019 by Kate
#####################################################################

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 1 ];
then
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -c|--catkin)
    CATKIN=${2%/} # strip trailing slash 
    shift # past argument
    shift # past value
    ;;
    -l|--logfile)
    LOGFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--basehostname)
    BASENAME="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--robohostname)
    ROBONAME="$2"
    shift # past argument
    shift # past value
    ;;
    -bip|--baseip)
    BASEIP="$2"
    shift # past argument
    shift # past value
    ;;
    -rip|--roboip)
    ROBOIP="$2"
    shift # past argument
    shift # past value
    ;;

esac
done
# TODO Error checking make sure catkin and logfile exist, and flagging to configure network if BASE/ROBO IP/NAMES aren't set (set defaults here)
echo $LOGFILE
if [ -z ${CATKIN} ];
then
    echo "ERROR: Must provide path to catkin workspace"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
    # TODO: Make sure $CATKIN is a valid directory
fi
# Set default log file if not provided with one
if [ -z ${LOGFILE} ];
then
    LOGFILE="tmp-logfile.txt"
fi
#######################
# Network configuration
#######################
# Make backup copies of current /etc/hosts /etc/hostname /etc/network/interfaces for backup with which to restore later
OLDEST="" # Mark oldest copies in this directory so they don't accidentally get overwritten if script is run dirty
if [ -d utils/netconfig/backups/ ]; then
   # If the backups directory is empty, these are the oldest backups
   [ "$(ls -A utils/netconfig/backups/)" ] || OLDEST="-oldest"
fi
cp /etc/hosts ./utils/netconfig/backups/hosts$OLDEST
cp /etc/hostname ./utils/netconfig/backups/hostname$OLDEST
cp /etc/network/interfaces ./utils/netconfig/backups/interfaces$OLDEST

# Overwrite files: /etc/network/interfaces /etc/hosts and /etc/hostname
# with the default ones defined in ./utils/netconfig/
cp ./utils/netconfig/hosts /etc/hosts
cp ./utils/netconfig/basehostname /etc/hostname
cp ./utils/netconfig/interfaces /etc/network/interfaces

# TODO:
# If network command line args were set, then use sed to edit the overwritten files

# TODO: 
# Check for dirty exit!!, replace /etc/hosts, hostname and interfaces files with backups in the kill script 
#diff files
#if exit code is 0 or 2 bad condition
EXITCODE=$(diff utils/netconfig/hosts /etc/hosts)$?
#EXITCODE=$(echo $?)
#EXITCODE=echo $?
echo "exit code"
echo $EXITCODE

exit(1)

#####################################################################
# Configure log and vars
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="usb-install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

SPHERE_LAUNCH="vive.launch"
DUAL_CAM_LAUNCH="dual-cam.launch"

#RVIZ_CONFIG_FILE="rviz_textured_sphere.rviz"
#RVIZ_CONFIG="rviz_cfg"

#####################################################################
 # Source devel/setup.bash 
#####################################################################
# shellcheck disable=SC1090
source "$CATKIN"/devel/setup.bash

#####################################################################
 # Launch Rviz and textured sphere
#####################################################################
echo "[INFO: $MYFILENAME $LINENO] Attempting to launch rviz textured sphere with $SPHERE_LAUNCH" >> "$LOGFILE"
roslaunch --wait rviz_textured_sphere $SPHERE_LAUNCH && #configfile:="${RVIZ_CONFIG_FILE}"
echo "[INFO: $MYFILENAME $LINENO] rviz_textured_sphere launched with $SPHERE_LAUNCH" >> "$LOGFILE"
