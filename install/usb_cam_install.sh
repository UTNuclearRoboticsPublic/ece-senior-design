#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 11/5/18

# Purpose:
#	This script installs the ROS package usb_cam if it is not already installed


# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN_RELATIVE=${1%/}
else
	echo "Usage: usb_cam_install.sh <path to catkin workspace>"
	exit 1
fi

FILENAME="usb_cam_install.sh"
MYFULLPATH=$(locate $FILENAME)	# Finds all copies of this file!!!!!!!
MYPATH=${MYFULLPATH%/*}
#ROOT=$PWD
#CATKIN=$ROOT/$CATKIN_RELATIVE	
CATKIN=$CATKIN_RELATIVE	
BUILD="build"
SRC="src"
DEST="usb_cam"
LAUNCH="launch"
CONFIG="config"
SINGLECAM="single-cam.launch"
DUALCAM="dual-cam.launch"

# Create catkin workspace subdirectories
#cd "$CATKIN"
mkdir -p "$CATKIN"/"$BUILD"
mkdir -p "$CATKIN"/"$SRC"

# Setup usb_cam
#cd $SRC
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ];
then
    git clone https://github.com/ros-drivers/usb_cam.git "$CATKIN"/"$SRC"/"$DEST"/
fi

#cd $MYPATH

# Take dual-cam.launch file located in config/
# 	and place it in usb_cam 'launch' directory
cp $MYPATH/$CONFIG/$SINGLECAM $CATKIN/$SRC/$DEST/$LAUNCH/ #$SINGLECAM
cp $MYPATH/$CONFIG/$DUALCAM $CATKIN/$SRC/$DEST/$LAUNCH/ #$DUALCAM
   
#if [ ! -f "$CATKIN/$SRC/$DEST/$LAUNCH/$DUALCAM" ];
#then
#    echo -e $DUALCAM_FILE >> $CATKIN/$SRC/$DEST/$LAUNCH/$DUALCAM
#fi

echo "USB cam installed."
