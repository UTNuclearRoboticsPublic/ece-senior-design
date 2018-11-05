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
	echo "Usage: usb-cam-install.sh <path to catkin workspace>"
	exit 1
fi	
	
ROOT=$PWD
CATKIN=$ROOT/$CATKIN_RELATIVE	
BUILD="build"
SRC="src"
DEST="usb_cam"
LAUNCH="launch"
CONFIG="config"
DUALCAM="dual-cam.launch"

# Create catkin workspace subdirectories
cd "$CATKIN"
mkdir -p "$BUILD"
mkdir -p "$SRC"

# Setup usb_cam
cd $SRC
if [ ! -d "$DEST" ];
then
    git clone https://github.com/ros-drivers/usb_cam.git
fi

echo "USB cam installed, now building catkin workspace."

# Take dual-cam.launch file located in config/
# 	and place it in usb_cam 'launch' directory
DUALCAM_FILE="
<launch>\n
 <arg name=\"cam1\" />\n
 <arg name=\"cam2\" />\n
 <group ns=\"camera1\">\n
  <node name=\"usb_cam1\" pkg=\"usb_cam\" type=\"usb_cam_node\" output=\"screen\" >\n
    <param name=\"video_device\" value=\"$(cam1)\" />\n
    <param name=\"image_width\" value=\"1280\" />\n
    <param name=\"image_height\" value=\"720\" />\n
    <param name=\"pixel_format\" value=\"mjpeg\" />\n
    <param name=\"camera_frame_id\" value=\"usb_cam1\" />\n
    <param name=\"io_method\" value=\"mmap\"/>\n
  </node>\n
  <node name=\"image_view\" pkg=\"image_view\" type=\"image_view\" respawn=\"false\" output=\"screen\">\n
    <remap from=\"image\" to=\"/camera1/usb_cam1/image_raw\"/>\n
    <param name=\"autosize\" value=\"true\" />\n
  </node>\n
 </group>\n
\n
 <group ns=\"camera2\">\n
  <node name=\"usb_cam2\" pkg=\"usb_cam\" type=\"usb_cam_node\" output=\"screen\" >\n
    <param name=\"video_device\" value=\"$(cam2)\" />\n
    <param name=\"image_width\" value=\"1280\" />\n
    <param name=\"image_height\" value=\"720\" />\n
    <param name=\"pixel_format\" value=\"mjpeg\" />\n
    <param name=\"camera_frame_id\" value=\"usb_cam2\" />\n
    <param name=\"io_method\" value=\"mmap\"/>\n
  </node>\n
  <node name=\"image_view\" pkg=\"image_view\" type=\"image_view\" respawn=\"false\" output=\"screen\">\n
    <remap from=\"image\" to=\"/camera2/usb_cam2/image_raw\"/>\n
    <param name=\"autosize\" value=\"true\" />\n
  </node>\n
 </group>\n
</launch>\n
<!-- NOTE: We should make resolution an argument passed from the outside -->" &> /dev/null

if [ ! -f "$CATKIN/$SRC/$DEST/$LAUNCH/$DUALCAM" ];
then
    echo -e $DUALCAM_FILE >> $CATKIN/$SRC/$DEST/$LAUNCH/$DUALCAM
fi

cd $ROOT

echo "USB Cam installed."
