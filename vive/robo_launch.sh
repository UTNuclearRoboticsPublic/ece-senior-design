#!/usr/bin/env bash
#####################################################################
# Purpose: Launch robot station part of the system including camera 
#          setup and publishing, and roscore master
# Authors: Kate Baumli, Daniel Diamont, Caleb Johnson
# Date:    01/28/2019
#####################################################################

export HELLO="hello"

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


#####################################################################
# Parse args
#####################################################################
#if [ $# -ne 5 -o $# -ne 6 ];
#then
	#echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b|--basehostname] [-bip|--baseip] [-r|--robohostname] [-rip|--roboip]"
    #exit 1
	#echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-nc|--force-default-netconfig] [-b|--basehostname] [-bip|--baseip] [-r|--robohostname] [-rip|--roboip]"
#fi

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
    #-nc|--use-custom-netconfig)
    #FORCE_DEFAULT_NETCONFIG="$2"
    #shift # past argument
    #shift # past value
    #;;
    -b|--basehostname)
    BASENAME="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--robohostname)
    ROBONAME="$2"
    shift # past argument
    shift # past value
    ;;
    -bip|--baseip)
    BASEIP="$2"
    shift # past argument
    shift # past value
    ;;
    -rip|--roboip)
    ROBOIP="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

if [ -z ${CATKIN} ];
then
    echo "ERROR: Must provide path to catkin workspace"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
    # TODO: Make sure $CATKIN is a valid directory
fi

if [ -z ${BASENAME} ];
then
    echo "ERROR: Must provide base station name"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
fi

if [ -z ${ROBONAME} ];
then
    echo "ERROR: Must provide robo station name"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
fi

if [ -z ${BASEIP} ];
then
    echo "ERROR: Must provide base station IP"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
else
    if ! valid_ip $BASEIP;
        then echo 'Invalid base station IP'; 
        exit 1;
    fi
fi

if [ -z ${ROBOIP} ];
then
    echo "ERROR: Must provide robo station IP"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
else
    if ! valid_ip $ROBOIP;
        then echo 'Invalid robot station IP'; 
        exit 1;
    fi
fi


#####################################################################
# Configure log and vars
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="robo_launch.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

SPHERE_LAUNCH="vive.launch"
SINGLE_CAM_LAUNCH="single-cam.launch"
DUAL_CAM_LAUNCH="dual-cam.launch"

#RVIZ_CONFIG_FILE="rviz_textured_sphere.rviz"
#RVIZ_CONFIG="rviz_cfg"

#####################################################################
# Camera parsing function  --- works for Kodaks only
#####################################################################
function find_cam_dev_name {
    # shellcheck disable=SC2044
    # shellcheck disable=SC2106
	for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
		(
			syspath="${sysdevpath%/dev}"
			devname="$(udevadm info -q name -p "$syspath")"
			[[ "$devname" == "bus/"* ]] && continue
			eval "$(udevadm info -q property --export -p "$syspath")"
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

export ROS_IP="$ROBOIP"
export ROS_MASTER_URI="http://$ROBOIP:11311"

#####################################################################
 # Source devel/setup.bash and start roscore
#####################################################################
# shellcheck disable=SC1090
source "$CATKIN"/devel/setup.bash
x-terminal-emulator -e roscore

#####################################################################
 # Configure and launch cameras
#####################################################################
CAMS=$(find_cam_dev_name);
echo "[INFO: $MYFILENAME $LINENO] Cameras found at $CAMS" >> "$LOGFILE"
CAM_ARR=($CAMS)

# Get the video number of each camera
i=$((${#CAM_ARR[0]}-1))
CAM1=${CAM_ARR:$i:1}
i=$((${#CAM_ARR[1]}-1))
CAM2=${CAM_ARR[1]:$i:1}

if [[ ${#CAM_ARR[@]} == 1 ]];
then
    roslaunch --wait video_stream_opencv $SINGLE_CAM_LAUNCH video_stream_provider1:="$CAM1" &
    echo "[INFO: $MYFILENAME $LINENO] One camera launched from ${CAM_ARR[0]}" >> "$LOGFILE"
elif [[ ${#CAM_ARR[@]} == 2 ]];
then
    roslaunch --wait video_stream_opencv $DUAL_CAM_LAUNCH video_stream_provider1:="$CAM1" video_stream_provider2:="$CAM2" &
    echo "[INFO: $MYFILENAME $LINENO] Two cameras launched from ${CAM_ARR[0]} and ${CAM_ARR[1]}" >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] No cameras launched. Devices found at: $CAMS" >> "$LOGFILE"
fi

