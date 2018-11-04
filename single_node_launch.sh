#/usr/bin/env bash
# Authors:	Kate Baumli & John Sigmon
# Date:		November 1, 2018
# Purpose:	This script launches all processes necessary to connect panospheric cameras to vive headset
#		 	via ros, rviz plugin, and steam vr


# 0 a) Load command args: check that user passed in catkin workspace path
if [ $# -ge 1 ]; 
then
	# Strip extra slash off of given catkin path (if there is one)
    CATKIN=$(echo $1 | sed 's:/*$::')
	VERBOSE=true # Optional argument whether or not to print stuff default true
	if [[ $# -ge 2 && $2 == "quiet" ]]; 
	then 
		VERBOSE=false # Only change quiet option
	fi
else
    echo "Usage: $0 <path to catkin workspace> [\"quiet\"]"
    exit 1
fi	

if [ $VERBOSE == "true" ];
then 
	echo "Launching VR camera system with catkin workspace $CATKIN..."
fi
# 0 b) set other variables	
BUILD="build"
SRC="src"
DEST="rviz_textured_sphere"
DEMOLAUNCH="demo.launch"
NEWLAUNCH="vive.launch"

# 1 Launch roscore (in its own terminal or background it)
if [ $VERBOSE == "true" ];
then 
	echo "Launching roscore..."
fi
x-terminal-emulator -e roscore

# 2 Source ros enviornment script
if [ $VERBOSE == "true" ];
then 
	echo "Configuring ros environment..."
fi
source $CATKIN/devel/setup.bash

# 3 Configure cameras (find device numbers and edit launch files)
if [ $VERBOSE == "true" ];
then 
	echo "Locating cameras..."
fi
USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/usb
num_cams=0
CAMS=$(bash utils/find_cam_dev_name.sh);
CAM_ARR=($CAMS)

# TODO: Check if we even still want to support single cam launch at all...
# If not just delete this if statement and make srue you have 2 cams plugged in
if [[ ${#CAM_ARR[@]} == 1 ]];
then 
	USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/single_cam.launch

elif [[ ${#CAM_ARR[@]} == 2 ]];
then 
	USB_CAM_LAUNCH=$CATKIN/src/usb_cam/launch/double_cam.launch
else
	echo "Error: Need 1 or 2 cameras plugged into USB (and turned on), found ${#CAM_ARR[@]}"
	source utils/kill_roscore.sh
	exit 1

fi

# 4 Launch usb cam in its own terminal 
if [ $VERBOSE == "true" ];
then 
	echo "Found ${#CAM_ARR[@]} cameras!"
	echo "Running $USB_CAM_LAUNCH $CAMS..."
fi
x-terminal-emulator -e roslaunch usb_cam $USB_CAM_LAUNCH $CAMS

# 5 Launch Steam VR (?)
if [ $VERBOSE == "true" ];
then
	echo "Launching SteamVR..."
fi
# could be: x-terminal-emulator -e steam steam://run/250820
# or could be: x-terminal-emulator -e /path/to/steam/Steam.exe -applaunch 250820
# seems to lauch in background so not helpful for debugging

# 6 Launch textured sphere / Rviz
if [ $VERBOSE == "true" ];
then
	echo ""
roslaunch rviz_textured_sphere demo.launch

# 7 Point Rviz to vive plugin (?) 
while :
do 
	:
done
