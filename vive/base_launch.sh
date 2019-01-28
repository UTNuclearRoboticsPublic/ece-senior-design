#!/usr/bin/env bash
#####################################################################
# Purpose: Launch base station part of the system including rviz, 
#          textured sphere, network, and VR plugin
# Authors: Kate Baumli, Daniel Diamont, Caleb Johnson
# Date:    01/28/2019
#####################################################################

#####################################################################
# Parse args
#####################################################################
if [ $# -ne 6 ];
then
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
	echo "OR  base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
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

if [ -z ${CATKIN} ];
then
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
	echo "OR  base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
fi

if [ -z ${LOGFILE} ];
then
    LOGFILE="tmp-logfile.txt"
fi
# TODO:
# 1) Always overwrite files: /etc/network/interfaces /etc/hosts and /etc/hostname
#    with the default ones in our repo (still need to make)
# 2) IF network command line args were set, use sed to edit the overwritten files

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
