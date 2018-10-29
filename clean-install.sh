# Author: Daniel Diamont
# Last Modified: 10-28-2018

# Purpose:
# 	This script will execute 4 installation scripts to set up a fully working
# 	ROS Kinetic environment with RVIZ, integration with USB Cameras, and
#	integration with the HTC Vive headset.
#
#
#	The scripts will be installed in the following order:
#		1. ros-install.sh
#		2. usb-cam-install.sh
#		3. vive-plugin-install.sh
#		4. textured-sphere-install.sh
#
#
#	Note: If any of the packages are already installed, the scripts will
#	simply skip over these
#


# Take the catkin workspace as a parameter from the user
if [ $# -eq 1 ];
then
	CATKIN=$1
else
	echo "Usage: clean-install.sh <path to catkin workspace>"
	exit 1
fi

# Get Current Path
ROOTPATH=`pwd`
UTILS="
# Run ros-install.sh

