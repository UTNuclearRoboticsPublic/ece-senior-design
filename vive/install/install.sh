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
if [[ $- == *i* ]]
then
	echo "Launching..."
else
	echo "Usage: bash -i install.sh <Path to catkin workspace directory>"
	echo "Did you forget the '-i'?"
    exit 1
fi

# Take the catkin workspace as a parameter from the user
if [ $# -eq 1 ];
then
	CATKIN_RELATIVE=${1%/}
else
	echo "Usage: bash -i install.sh <Path to catkin workspace directory>"
	echo "Did you forget the '-i'?"
	exit 1
fi

timestamp() {
      date +"%T"
}

# TODO check catkin relative for absolute and ~
CATKIN_ABS=$PWD/$CATKIN_RELATIVE
MYFILENAME="install.sh"
LOGFILE="log$(timestamp)$MYFILENAME.txt"
UTILS="utils"
scriptdir="$(dirname "$0")"
cd "$scriptdir" || exit

#####################################################################
# Install dependencies
#####################################################################
if dpkg -s git &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] git is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing git." >> "$LOGFILE"
    sudo apt-get install git &&
    echo "[INFO: $MYFILENAME $LINENO] Installed git." >> "$LOGFILE"
fi

if dpkg -s python-catkin-pkg &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] python-catkin-pkg is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing python-catkin-pkg." >> "$LOGFILE"
	sudo apt-get install python-catkin-pkg &&
    echo "[INFO: $MYFILENAME $LINENO] Installed python-catkin-pkg." >> "$LOGFILE"
fi

if dpkg -s cmake &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] cmake is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing cmake." >> "$LOGFILE"
	sudo apt-get install cmake &&
    echo "[INFO: $MYFILENAME $LINENO] Installed cmake." >> "$LOGFILE"
fi

if dpkg -s python-empy &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] python-empy is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing python-empy." >> "$LOGFILE"
	sudo apt-get install python-empy &&
    echo "[INFO: $MYFILENAME $LINENO] Installed python-empy." >> "$LOGFILE"
fi

if dpkg -s v4l-utils &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] v4l-utils is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing v4l-utils." >> "$LOGFILE"
	sudo apt-get install v4l-utils &&
    echo "[INFO: $MYFILENAME $LINENO] Installed v4l-utils." >> "$LOGFILE"
fi

if dpkg -s python-nose &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] python-nose is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing python-nose." >> "$LOGFILE"
	sudo apt-get install python-nose &&
    echo "[INFO: $MYFILENAME $LINENO] Installed python-nose." >> "$LOGFILE"
fi

if dpkg -s python-setuptools &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] python-setuptools is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing python-setuptools." >> "$LOGFILE"
	sudo apt-get install python-setuptools &&
    echo "[INFO: $MYFILENAME $LINENO] Installed python-setuptools." >> "$LOGFILE"
fi

if dpkg -s libgtest-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libgtest-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing libgtest-dev." >> "$LOGFILE"
	sudo apt-get install libgtest-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed libgtest-dev." >> "$LOGFILE"
fi

if dpkg -s build-essential &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] build-essential is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing build-essential." >> "$LOGFILE"
	sudo apt-get install build-essential &&
    echo "[INFO: $MYFILENAME $LINENO] Installed build-essential." >> "$LOGFILE"
fi

#####################################################################
# Install ROS-Kinetic
#####################################################################
bash -i "$UTILS"/ros_install.sh -l "$LOGFILE"

if dpkg -s ros-kinetic-catkin &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] ros-kinetic-catkin is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing ros-kinetic-catkin." >> "$LOGFILE"
    sudo apt-get install ros-kinetic-catkin &&
    echo "[INFO: $MYFILENAME $LINENO] Installed ros-kinetic-catkin." >> "$LOGFILE"
fi

#############################################################################
# Install OpenCV Video streaming package, stitching plug-in, and Vive plug-in
#############################################################################
bash -i "$UTILS"/cv_video_stream_install.sh -c "$CATKIN_ABS" -l "$LOGFILE"
bash -i "$UTILS"/rviz_textured_sphere_install.sh -c "$CATKIN_ABS" -l "$LOGFILE"
bash -i "$UTILS"/vive_plugin_install.sh -c "$CATKIN_ABS" -l "$LOGFILE"

# shellcheck disable=SC1091
source /opt/ros/kinetic/setup.bash
echo "[INFO: $MYFILENAME $LINENO] Install finished." >> "$LOGFILE"
