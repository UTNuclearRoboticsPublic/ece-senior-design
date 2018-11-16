# Author: Daniel Diamont
# Modifications: John Sigmon

# Last Modified: 11-15-2018

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

# Why is this necessary
# Check if shell was launched with interactive mode '-i'
if [[ $- == *i* ]]
then
	echo "Launching..."
else
	echo "Usage: bash -i clean-install.sh <Path to catkin workspace directory>"
	exit 1
fi

#scriptdir="$(dirname "$0")"
#cd "$scriptdir" 
#I think this is unnecessary^^

# Take the catkin workspace as a parameter from the user
if [ $# -eq 1 ];
then
	CATKIN_RELATIVE=${1%/}
else
	echo "Usage: clean-install.sh <path to catkin workspace directory>"
	exit 1
fi

timestamp() {
      date +"%T"
}

LOGFILE="log$(timestamp).txt"
MYFILENAME="clean-install.sh"
UTILS="utils"
INSTALL="install"
CONFIG="config"

# Set up log


# Install git if not already installed

dpkg -s git &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] git is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing git."
    sudo apt-get install git &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed git."
fi

# Install dependencies if not already installed
dpkg -s python-catkin-pkg &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] python-catkin-pkg is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing python-catkin-pkg."
	sudo apt-get install python-catkin-pkg &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed python-catkin-pkg."
fi

dpkg -s cmake &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] cmake is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing cmake."
	sudo apt-get install cmake &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed cmake."
fi

dpkg -s python-empy &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] python-empy is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing python-empy."
	sudo apt-get install python-empy &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed python-empy."
fi

dpkg -s v4l-utils &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] v4l-utils is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing v4l-utils."
	sudo apt-get install v4l-utils &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed v4l-utils."
fi

dpkg -s python-nose &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] python-nose is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing python-nose."
	sudo apt-get install python-nose &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed python-nose."
fi

dpkg -s python-setuptools &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] python-setuptools is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing python-setuptools."
	sudo apt-get install python-setuptools &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed python-setuptools."
fi

dpkg -s libgtest-dev &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] libgtest-dev is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing libgtest-dev."
	sudo apt-get install libgtest-dev &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed libgtest-dev."
fi

dpkg -s build-essential &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] build-essential is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing build-essential."
	sudo apt-get install build-essential &&
    echo "[INFO: $MYFILENAME $LINENO ] Installed build-essential."
fi

# Run ros-install.sh
bash -i $INSTALL/ros-install.sh ../$CATKIN_RELATIVE
#source ~/.bashrc NECESSARY?

# Install catkin if not already installed

dpkg -s ros-kinetic-catkin &> /dev/null

if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO ] ros-kinetic-catkin is already installed, skipping installation."
else
    echo "[INFO: $MYFILENAME $LINENO ] Installing ros-kinetic-catkin."
    sudo apt-get install ros-kinetic-catkin
    echo "[INFO: $MYFILENAME $LINENO ] Installed ros-kinetic-catkin."
fi

#dpkg -s catkin &> /dev/null

#if [ $? -eq 0 ]; then
#    echo "catkin is already installed!"
#else
#    echo "catkin is NOT installed. Installing catkin now!"
#        sudo apt install catkin
#fi
#
#source ~/.bashrc


# Run usb-cam-install.sh
bash -i $INSTALL/usb-cam-install.sh $CATKIN_RELATIVE

# Run textured-sphere-install.sh
bash -i $INSTALL/textured-sphere-install.sh $CATKIN_RELATIVE

# Run vive-plugin-install.sh
bash -i $INSTALL/vive-plugin-install.sh $CATKIN_RELATIVE

source /opt/ros/kinetic/setup.bash

echo "Clean Install finished!"
