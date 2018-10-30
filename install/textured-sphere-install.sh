#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 10/26/18

# Purpose:
#	This script installs the rviz_textured_sphere plugin from the 
#	UTNuclearRoboticsGroup public repository


# Check that user passed in catkin workspace path
if [ $# -eq 2 ]; 
then
	CATKIN=$1
	ROOTPATH=$2
else
	echo "Usage: textured-sphere-install.sh <path to catkin workspace> \
		<top level install directory>"
	exit 1
fi	
	
BUILD="build"
SRC="src"
DEST="rviz_textured_sphere"
DEMOLAUNCH="demo.launch"
NEWLAUNCH="vive.launch"

# Create catkin workspace directory if it does not already exist
mkdir -p "$CATKIN"
cd "$CATKIN"
mkdir -p "$BUILD"
mkdir -p "$SRC"

# Setup rviz textured sphere 
cd $SRC
if [ ! -d "$DEST" ];
then
    git clone https://github.com/UTNuclearRoboticsPublic/rviz_textured_sphere.git
else
	echo "rviz_textured_sphere is already installed!"
fi

# Cmake
cd $DEST 
cmake ..

# Make new launch file and edit it
cat launch/$DEMOLAUNCH > launch/$NEWLAUNCH
sed -i '$i\
    launch-prefix="${HOME}/.steam/steam/ubuntu12_32/steam-runtime/run.sh" />' launch/$NEWLAUNCH
sed -i '5s/\/>//' launch/$NEWLAUNCH

cd $CATKIN

echo "Textured Sphere Plugin installed."