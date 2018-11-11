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
#	if [[ $# -ge 2 && $2 == "--quiet" || "quiet" || "q" || "-q"  ]]; 
#	then 
#		VERBOSE=false # Only change quiet option
#    fi
else
    echo "Usage: $0 <path to catkin workspace> [-q --quiet]"
    exit 1
fi	

LOGFILE="log.txt"

BUILD="build"
SRC="src"
LAUNCH="launch"

SPHERE="rviz_textured_sphere"
SPHERE_LAUNCH="vive.launch"
USB_CAM="usb_cam"
SINGLE_CAM_LAUNCH="single-cam.launch"
DUAL_CAM_LAUNCH="dual-cam.launch"

# Declaring usb camera finding function
function find_cam_dev_name {
	for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
		(
			syspath="${sysdevpath%/dev}"
			devname="$(udevadm info -q name -p $syspath)"
			[[ "$devname" == "bus/"* ]] && continue
			eval "$(udevadm info -q property --export -p $syspath)"
			[[ -z "$ID_SERIAL" ]] && continue
			if [[ "$devname" == "video"* ]] 
				then
					if [[ "$ID_SERIAL" == *"KODAK"* ]]
						then
							echo "/dev/$devname"
					fi
			fi
		)
	done
}

# Delete old log file, make new one
if [ -f "$CATKIN/$LOGFILE" ];
then
    rm -f $CATKIN/$LOGFILE
fi

if [ "$VERBOSE" ];
then 
	echo "Launching system from $CATKIN" >> $CATKIN/$LOGFILE
fi

########################################################################
# roslaunch does this on its own                                       #
########################################################################

# 1 Launch roscore (in its own terminal or background it)
#if [ $VERBOSE == "true" ];
#then 
#	echo "Launching roscore..."
#fi
#x-terminal-emulator -e roscore

# 2 Source ros enviornment script
if [ $VERBOSE == "true" ];
then 
	echo -e "Configuring ros environment" >> $CATKIN/$LOGFILE
fi
source $CATKIN/devel/setup.bash

# 3 Configure cameras (find device numbers and edit launch files)
if [ $VERBOSE == "true" ];
then 
	echo "Locating cameras" >> $CATKIN/$LOGFILE
fi

CAMS=$(find_cam_dev_name);
CAM_ARR=($CAMS)

if [[ ${#CAM_ARR[@]} == 1 ]];
then 
#    x-terminal-emulator -e roslaunch usb_cam $SINGLE_CAM_LAUNCH cam1:="${CAM_ARR[0]}"
    roslaunch usb_cam $SINGLE_CAM_LAUNCH cam1:="${CAM_ARR[0]}" &
    echo "${CAM_ARR[0]}" >> $CATKIN/$LOGFILE

elif [[ ${#CAM_ARR[@]} == 2 ]];
then 
#    x-terminal-emulator -e roslaunch usb_cam $DUAL_CAM_LAUNCH cam1:="${CAM_ARR[0]}" cam2:="${CAM_ARR[1]}"
    roslaunch usb_cam $DUAL_CAM_LAUNCH cam1:="${CAM_ARR[0]}" cam2:="${CAM_ARR[1]}" &
    echo "${CAM_ARR[0]}" >> $CATKIN/$LOGFILE 
    echo "${CAM_ARR[1]}" >> $CATKIN/$LOGFILE 

else
	echo "Error: Need 1 or 2 cameras plugged into USB (and turned on), found ${#CAM_ARR[@]}" >> $CATKIN/$LOGFILE
	#bash kill_launch.sh 	# We don't want to crash the program
	#exit 1
fi
 
if [ $VERBOSE == "true" ];
then 
	echo "Found ${#CAM_ARR[@]} cameras!" >> $CATKIN/$LOGFILE
	echo "Running $USB_CAM_LAUNCH $CAMS" >> $CATKIN/$LOGFILE
fi

# 5 Launch Steam VR (?)
if [ $VERBOSE == "true" ];
then
	echo "Launching SteamVR..." >> $CATKIN/$LOGFILE
fi

x-terminal-emulator -e steam steam://run/250820 &> /dev/null
# or could be: x-terminal-emulator -e /path/to/steam/Steam.exe -applaunch 250820

# 6 Launch textured sphere / Rviz
if [ $VERBOSE == "true" ];
then
	echo "Launching textured sphere in rviz" >> $CATKIN/$LOGFILE
fi
roslaunch rviz_textured_sphere $SPHERE_LAUNCH

# 7 Point Rviz to vive plugin (?)
