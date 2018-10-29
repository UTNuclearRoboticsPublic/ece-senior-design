#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 10/26/18

# Purpose:
#	This script installs the ROS package usb_cam if it is not already installed


# Check that user passed in catkin workspace path
if [ $# -eq 2 ]; 
then
	CATKIN=$1
	TOPLEVEL=$2
else
	echo "Usage: usb-cam-install.sh <path to catkin workspace> \
		<top level install directory>"
	exit 1
fi	
	
BUILD="build"
SRC="src"
DEST="usb_cam"
LAUNCH="launch"
CONFIG="config"
DUALCAM="dual-cam.launch"

# Create catkin workspace directory if it does not already exist
mkdir -p "$CATKIN"
cd "$CATKIN"
mkdir -p "$BUILD"
mkdir -p "$SRC"

# Setup usb_cam
cd $SRC
if [ ! -d "$DEST" ];
then
    git clone https://github.com/ros-drivers/usb_cam.git
fi

# Take dual-cam.launch file located in config/
# 	and place it in usb_cam 'launch' directory
cp $TOPLEVEL/$CONFIG/$DUALCAM $CATKIN/$SRC/$DEST/$LAUNCH/$DUALCAM

cd $CATKIN
echo "USB cam installed, now building catkin workspace."

source ~/.bashrc
