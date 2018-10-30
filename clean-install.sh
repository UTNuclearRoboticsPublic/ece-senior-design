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


# Check if shell was launched with interactive mode '-i'
if [[ $- == *i* ]]
then
	echo "Launching..."
else
	echo "Usage: bash -i clean-install.sh <full path to catkin workspace directory>"
	exit 1
fi

scriptdir="$(dirname "$0")"
cd "$scriptdir"

# Take the catkin workspace as a parameter from the user
if [ $# -eq 1 ];
then
	CATKIN=$1
else
	echo "Usage: clean-install.sh <full path to catkin workspace directory>"
	exit 1
fi



# Install git if not already installed

dpkg -s git &> /dev/null

if [ $? -eq 0 ]; then
    echo "git is already installed!"
else
    echo "git is NOT installed. Installing git now!"
        sudo apt-get install git
fi

# Install bootstrap dependencies if not already installed
dpkg -s python-catkin-pkg &> /dev/null

if [ $? -eq 0 ]; then
    echo "python-catkin-pkg is already installed!"
else
    echo "python-catkin-pkg is NOT installed. Installing python-catkin-pkg now!"
	sudo apt-get install python-catkin-pkg
fi


dpkg -s cmake &> /dev/null
if [ $? -eq 0 ]; then
    echo "cmake is already installed!"
else
    echo "cmake is NOT installed. Installing now!"
	sudo apt-get install cmake
fi


dpkg -s python-empy &> /dev/null
if [ $? -eq 0 ]; then
    echo "python-empy is already installed!"
else
    echo "python-empy is NOT installed. Installing python-empy now!"
	sudo apt-get install python-empy
fi

dpkg -s python-nose &> /dev/null
if [ $? -eq 0 ]; then
    echo "python-nose is already installed!"
else
    echo "python-nose is NOT installed. Installing python-nose now!"
	sudo apt-get install python-nose
fi

dpkg -s python-setuptools &> /dev/null
if [ $? -eq 0 ]; then
    echo "python-setuptools is already installed!"
else
    echo "python-setuptools is NOT installed. Installing python-setuptools now!"
	sudo apt-get install python-setuptools
fi


dpkg -s libgtest-dev &> /dev/null
if [ $? -eq 0 ]; then
    echo "libgtest-dev is already installed!"
else
    echo "libgtest-dev is NOT installed. Installing libgtest-dev now!"
	sudo apt-get install libgtest-dev
fi

dpkg -s build-essential &> /dev/null
if [ $? -eq 0 ]; then
    echo "build-essential is already installed!"
else
    echo "build-essential is NOT installed. Installing build-essential now!"
	sudo apt-get install build-essential
fi


# Get Current Path (top-level directory of install)
ROOTPATH=`pwd`

# Set useful paths
UTILS="utils"
INSTALL="install"
CONFIG="config"

# Run ros-install.sh
bash -i $ROOTPATH/$INSTALL/ros-install.sh $CATKIN
source ~/.bashrc

# sudo apt-get update &> /dev/null

# Install catkin if not already installed

dpkg -s ros-kinetic-catkin &> /dev/null

if [ $? -eq 0 ]; then
    echo "ros-kinetic-catkin is already installed!"
else
    echo "ros-kinetic-catkin is NOT installed. Installing ros-kinetic-catkin now!"
        sudo apt-get install ros-kinetic-catkin
fi

source ~/.bashrc

#dpkg -s catkin &> /dev/null

#if [ $? -eq 0 ]; then
#    echo "catkin is already installed!"
#else
#    echo "catkin is NOT installed. Installing catkin now!"
#        sudo apt install catkin
#fi
#
#source ~/.bashrc

cd $CATKIN
catkin_make

# Run usb-cam-install.sh
bash -i $ROOTPATH/$INSTALL/usb-cam-install.sh $CATKIN $ROOTPATH

# Run textured-sphere-install.sh
bash -i $ROOTPATH/$INSTALL/textured-sphere-install.sh $CATKIN $ROOTPATH

# Run vive-plugin-install.sh
bash -i $ROOTPATH/$INSTALL/vive-plugin-install.sh $CATKIN $ROOTPATH

echo "Clean Install finished! Now building catkin workspace"

cd $CATKIN
catkin_make



