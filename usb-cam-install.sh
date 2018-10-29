#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 10/26/18

# Purpose:
#	This script installs the ROS package usb_cam if it is not already installed


# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN=$1
else
	echo "Usage: usb-cam-install.sh <path to catkin workspace>"
	exit 1
fi	
	
BUILD="build"
SRC="src"
DEST="usb_cam"

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

cd ../
echo "USB cam installed, now building catkin workspace."

catkin_make
