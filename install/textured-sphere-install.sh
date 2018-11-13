#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 11/5/18

# Purpose:
#	This script installs the rviz_textured_sphere plugin from the 
#	UTNuclearRoboticsGroup public repository


# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN_RELATIVE=${1%/}
else
	echo "Usage: textured-sphere-install.sh <path to catkin workspace>"
	exit 1
fi

FILENAME="textured-sphere-install.sh"
MYFULLPATH=$(locate $FILENAME)	# Finds all copies of this file!!!!!!!
MYPATH=${MYFULLPATH%/*}
#ROOT=$PWD
#CATKIN=$ROOT/$CATKIN_RELATIVE	
CATKIN=$CATKIN_RELATIVE	
BUILD="build"
SRC="src"
DEST="rviz_textured_sphere"
INSTALL="install"
CONFIG="config"
LAUNCH="launch"
DEMOLAUNCH="demo.launch"
VIVELAUNCH="vive.launch"
RVIZ_CONFIG="vive_launch_config.rviz"
RVIZ_CONFIG_FOLDER="rviz_cfg" 

# Create catkin workspace subdirectories
#cd "$CATKIN"
mkdir -p "$CATKIN"/"$BUILD"
mkdir -p "$CATKIN"/"$SRC"

# Setup rviz textured sphere 
#cd $SRC
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ];
then
    git clone https://github.com/UTNuclearRoboticsPublic/rviz_textured_sphere.git "$CATKIN"/"$SRC"/"$DEST"
else
	echo "rviz_textured_sphere is already installed!"
fi

# Cmake
#cd $CATKIN/$SRC/$DEST
#:cmake .

#cd $MYPATH

# Make new launch file and edit it
cp $MYPATH/$CONFIG/$VIVELAUNCH $CATKIN/$SRC/$DEST/$LAUNCH/$VIVELAUNCH

# Move rviz config file to proper location
cp $MYPATH/$CONFIG/$RVIZ_CONFIG $CATKIN/$SRC/$DEST/$RVIZ_CONFIG_FOLDER/$RVIZ_CONFIG
echo "Textured Sphere Plugin installed."
