#/usr/bin/env bash
# Authors:	Kate Baumli & John Sigmon & Beathan
# Date:		November 4, 2018
# Purpose:	This script kills all launches used in single_node_launch.sh
#		 	via ros, rviz plugin, and steam vr

STEAM=$(ps -uf | awk '/steam/ {print $2}')
kill $STEAM 2> /dev/null

ROSCORE=$(ps -uf | awk '/roscore/ {print $2}')
kill $ROSCORE 2> /dev/null

LAUNCHSCRIPT=$(ps -uf | awk '/node_launch.sh/ {print $2}')
kill -9 $LAUNCHSCRIPT 2> /dev/null

ROSLAUNCH=$(ps -uf | awk '/roslaunch/ {print $2}')
kill -9 $ROSLAUNCH 2> /dev/null

RVIZ=$(ps -ef | awk '/rviz/ {print $2}')
kill -9 $RVIZ 2> /dev/null

USB_CAM=$(ps -ef | awk '/usb/ {print $2}')
kill -9 $USB_CAM 2> /dev/null