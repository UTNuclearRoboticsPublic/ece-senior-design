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
LAUNCH="launch"

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

# Create dual-cam.launch file
echo "<launch>
 <arg name=\"cam1\" />
 <arg name=\"cam2\" />
 <group ns="camera1">
  <node name="usb_cam1" pkg="usb_cam" type="usb_cam_node" output="screen" >
    <param name="video_device" value="$(cam1)" />
    <param name="image_width" value="1280" />
    <param name="image_height" value="720" />
    <param name="pixel_format" value="mjpeg" />
    <param name="camera_frame_id" value="usb_cam1" />
    <param name="io_method" value="mmap"/>
  </node>
  <node name="image_view" pkg="image_view" type="image_view" respawn="false" output="screen">
    <remap from="image" to="/camera1/usb_cam1/image_raw"/>
    <param name="autosize" value="true" />
  </node>
 </group>

<group ns="camera2">
  <node name="usb_cam2" pkg="usb_cam" type="usb_cam_node" output="screen" >
    <param name="video_device" value="$(cam2)" />
    <param name="image_width" value="1280" />
    <param name="image_height" value="720" />
    <param name="pixel_format" value="mjpeg" />
    <param name="camera_frame_id" value="usb_cam2" />
    <param name="io_method" value="mmap"/>
  </node>
  <node name="image_view" pkg="image_view" type="image_view" respawn="false" output="screen">
    <remap from="image" to="/camera2/usb_cam2/image_raw"/>
    <param name="autosize" value="true" />
  </node>
 </group>
</launch>
<!-- NOTE: We should make resolution an argument passed from the outside -->
" > $DEST/$LAUNCH/dual-cam.launch

cd ../
echo "USB cam installed, now building catkin workspace."

catkin_make
