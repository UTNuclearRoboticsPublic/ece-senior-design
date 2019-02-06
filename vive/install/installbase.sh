#!/usr/bin/env bash
#
# Author: Daniel Diamont
# Modifications: John Sigmon, Kate Baumli, & Beathan Andersen

# Last Modified: 12-11-2018

# Purpose:
# 	This script will execute 4 installation scripts to set up a fully working
# 	ROS Kinetic environment with RVIZ, integration with USB Cameras, and
#	integration with the HTC Vive headset.
#
#
#	The scripts will be installed in the following order:
#		1. ros-install.sh
#		2. cv-camera-install.sh
#		3. vive-plugin-install.sh
#		4. textured-sphere-install.sh
#
#
#	Note: If any of the packages are already installed, the scripts will
#	simply skip over these
#

# Check if shell was launched with interactive mode '-i'
#if [[ $- == *i* ]]
#then
#	echo "Launching..."
#else
#	echo "Usage: bash -i install.sh <Path to catkin workspace directory>"
#	echo "Did you forget the '-i'?"
#    exit 1
#fi

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: single_node_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
	exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--catkin)
    CATKIN_RELATIVE=${2%/} # strip trailing slash
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

# TODO check catkin relative for absolute and ~
CATKIN_ABS=$PWD/$CATKIN_RELATIVE
MYFILENAME="install.sh"
LOGFILE="log_${MYFILENAME}_$(timestamp).txt"
LOGDIR="logs"
mkdir -p "$CATKIN_RELATIVE"
mkdir -p "$CATKIN_RELATIVE"/"$LOGDIR"
LOGPATH="$CATKIN_ABS"/"$LOGDIR"/"$LOGFILE"
UTILS="utils"
scriptdir="$(dirname "$0")"
cd "$scriptdir" || exit

#####################################################################
# Install dependencies
#####################################################################
sudo apt-get update && apt-get -y install build-essential=12.1ubuntu2\
                        cmake=3.5.1-1ubuntu3\
                        git\
                        libgtest-dev=1.7.0-4ubuntu1\
                        v4l-utils=1.10.0-1 2>&1 | tee -a "$LOGPATH"

#                    python-empy\ 
#                    python-nose\
#                    python-setuptools\

#####################################################################
# Install ROS-Kinetic, OpenCV Video streaming package, 
# stitching plug-in, and Vive plug-in
#####################################################################
bash "$UTILS"/ros_install.sh -l "$LOGPATH" 2>&1 | tee -a "$LOGPATH"
bash "$UTILS"/open_cv_video_stream_install.sh -c "$CATKIN_ABS" -l "$LOGPATH" 2>&1 | tee -a "$LOGPATH"
bash "$UTILS"/rviz_textured_sphere_install.sh -c "$CATKIN_ABS" -l "$LOGPATH" 2>&1 | tee -a "$LOGPATH"
bash "$UTILS"/vive_plugin_install.sh -c "$CATKIN_ABS" -l "$LOGPATH" 2>&1 | tee -a "$LOGPATH"

# shellcheck disable=SC1091
source /opt/ros/kinetic/setup.bash
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "[INFO: $MYFILENAME $LINENO] Install finished." 2>&1 | tee -a "$LOGPATH"

####################################################################
# Set ROS environment variables and set up network files
####################################################################
echo 'export ROS_MASTER_URI=http://robo:11311'>>~/.bashrc
echo 'export ROS_IP=10.0.0.2'>>~/.bashrc

> /etc/hosts
echo '127.0.0.1       localhost'>>/etc/hosts
echo '10.0.0.1        base'>>/etc/hosts
echo '10.0.0.2        robo'>>/etc/hosts