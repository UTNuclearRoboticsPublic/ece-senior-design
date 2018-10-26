#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 10/26/18

# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN=$1
else
	echo "Usage: textured-sphere-install.sh <path to catkin workspace>"
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
fi

# Cmake
cd $DEST 
cmake ..

# Make new launch file and edit it
cat launch/$DEMOLAUNCH > launch/$NEWLAUNCH
sed -i '$i\
    launch-prefix="${HOME}/.steam/steam/ubuntu12_32/steam-runtime/run.sh" />' launch/$NEWLAUNCH
sed -i '5s/\/>//' launch/$NEWLAUNCH

cd ../../
echo "Textured Sphere Plugin installed, now building catkin workspace."
catkin_make
