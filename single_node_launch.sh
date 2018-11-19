#/usr/bin/env bash
#
# Authors:	Kate Baumli & John Sigmon
#Last modified: 11-18-18
# Purpose:	This script launches all processes necessary to connect panospheric cameras to vive headset
#		 	via ros, rviz plugin, and steam vr

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: single_node_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
	exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--catkin)
    CATKIN=${2%/} # strip trailing slash
    shift # past argument
    shift # past value
    ;;
    -l|--logfile)
    LOGFILE="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

#####################################################################
# Configure log and vars
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="usb-install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)"$MYFILENAME".txt"
fi

BUILD="build"
SRC="src"
LAUNCH="launch"

SPHERE="rviz_textured_sphere"
SPHERE_LAUNCH="vive.launch"
USB_CAM="usb_cam"
SINGLE_CAM_LAUNCH="single-cam.launch"
DUAL_CAM_LAUNCH="dual-cam.launch"

#RVIZ_CONFIG_FILE="rviz_textured_sphere.rviz"
#RVIZ_CONFIG="rviz_cfg"

#####################################################################
# Camera parsing function  --- works for Kodaks only
#####################################################################
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

#####################################################################
 # Source devel/setup.bash and start roscore
#####################################################################
source $CATKIN/devel/setup.bash
x-terminal-emulator -e roscore

#####################################################################
 # Configure and launch cameras
#####################################################################
CAMS=$(find_cam_dev_name);
echo "[INFO: $MYFILENAME $LINENO] Cameras found at "$CAMS"" >> $LOGFILE
CAM_ARR=($CAMS)

if [[ ${#CAM_ARR[@]} == 1 ]];
then
    roslaunch --wait usb_cam $SINGLE_CAM_LAUNCH cam1:="${CAM_ARR[0]}" &
    echo "[INFO: $MYFILENAME $LINENO] One camera launched from "${CAM_ARR[0]}"" >> $LOGFILE
elif [[ ${#CAM_ARR[@]} == 2 ]];
then
    roslaunch --wait usb_cam $DUAL_CAM_LAUNCH cam1:="${CAM_ARR[0]}" cam2:="${CAM_ARR[1]}" &
    echo "[INFO: $MYFILENAME $LINENO] Two cameras launched from "${CAM_ARR[0]}" and "${CAM_ARR[1]}"" >> $LOGFILE
else
	echo "[INFO: $MYFILENAME $LINENO] No cameras launched. Devices found at: "$CAMS"" >> $LOGFILE
fi

#####################################################################
 # Launch Rviz and textured sphere
#####################################################################
roslaunch --wait rviz_textured_sphere $SPHERE_LAUNCH #configfile:="${RVIZ_CONFIG_FILE}"
echo "[INFO: $MYFILENAME $LINENO] rviz_textured_sphere launched with "$SPHERE_LAUNCH" >> $LOGFILE
