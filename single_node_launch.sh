#/usr/bin/env
# Authors:	Kate Baumli & John Sigmon
# Date:		October 28, 2018
# Purpose:	This script launches all processes necessary to connect panospheric cameras to vive headset
#		 	via ros, rviz plugin, and steam vr


# 0 a) Load command args: check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
    CATKIN=$1
	# Strip extra slash off TODO
else
    echo "Usage: single_node_launch.sh <path to catkin workspace>"
    exit 1
fi	
# 0 b) set other variables	
BUILD="build"
SRC="src"
DEST="rviz_textured_sphere"
DEMOLAUNCH="demo.launch"
NEWLAUNCH="vive.launch"

# 1 Launch roscore (in its own terminal or background it)
x-terminal-emulator -e roscore

# 2 Source ros enviornment script
source $CATKIN/devel/setup.bash

# 3 Configure cameras (find device numbers and edit launch files)
USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/usb
num_cams=0
CAMS=$(bash utils/find_cam_dev_name.sh);
CAM_ARR=($CAMS)

if [[ ${#CAM_ARR[@]} == 1 ]];
then 
	USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/single_cam.launch
fi

if [[ ${#CAM_ARR[@]} == 2 ]];
then 
	USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/double_cam.launch
fi

echo $USB_CAM_LAUNCH $CAMS

# 4 Launch usb cam in its own terminal 
## x-terminal-emulator -e $USB_CAM_LAUNCH $CAMS

# 5 Launch Steam VR (?)

# 6 Launch textured sphere / Rviz

# 7 Point Rviz to vive plugin (?) 
