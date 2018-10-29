#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 10/26/18

# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN=$1
else
	echo "Usage: vive-plugin-install.sh <path to catkin workspace>"
	exit 1
fi	
	
BUILD="build"
SRC="src"
DEST="rviz_vive"
ROOTPATH=`pwd`

# Create catkin workspace directory if it does not already exist
mkdir -p "$CATKIN"
cd "$CATKIN"
mkdir -p "$BUILD"
mkdir -p "$SRC"

# Install OGRE
## check if installed
dpkg -s libogre-1.9-dev &> /dev/null

if [ $? -eq 0 ]; then
    echo "OGRE is already installed!"
else
    echo "OGRE  is NOT installed!"
	sudo apt-get install libogre-1.9-dev
fi


# Install Steam
## check if steam is installed
dpkg -s steam &> /dev/null

if [ $? -eq 0 ]; then
    echo "Steam is already installed!"
else
    echo "Steam is NOT installed!"
	sudo apt-key adv \
  		--keyserver keyserver.ubuntu.com \
  		--recv-keys F24AEA9FB05498B7
	REPO="deb http://repo.steampowered.com/steam/ $(lsb_release -cs) steam"
	echo "${REPO}" > /tmp/steam.list
	sudo mv /tmp/steam.list /etc/apt/sources.list.d/ && sudo apt-get update
	sudo apt-get install -y steam

	# Steam Installer is broken... these are the steps that the installer tries to do
	mv ~/.steam/steam/* ~/.local/share/Steam/
	rmdir ~/.steam/steam
	ln -s ../.local/share/Steam ~/.steam/steam
	rm -rf ~/.steam/bin
fi


# do not know if we need this...
#export QT_SELECT=5

# also don't know if we need this (maybe for running OpenVR samples??)
# Install g++ version 4.9
# sudo apt-get install g++-4.9

# OpenVR Install
cd $SRC
## install OpenVR repo if directory 'openvr' does not exist
if [ ! -d "openvr" ]; then
	echo "OpenVR repo does not exist. Pulling OpenVR repository!" 
	git clone https://github.com/ValveSoftware/openvr.git
else
	echo "OpenVR repo already exists!"
fi

# Don't know if we need this (also for maybe running openvr samples
# Andre Gilerson said he never had to rebuild openVR binaries... just use included
#cd openvr/samples/
#mkdir build
#cd build
#cmake ..
#CXX=g++-4.9 cmake ../
#make

# Vive Plugin Install
## install rviz_vive plugin repo if directory 'rviz_vive' does not exist
if [ ! -d "rviz_vive" ]; then
	echo "rviz_vive plugin repo does not exist. Pulling rviz_vive repository!"
	git clone https://github.com/AndreGilerson/rviz_vive.git
	sed -i "30s|.*|set(OPENVR \"${ROOTPATH}\/${CATKIN}\/${SRC}\/openvr\")|" \
			rviz_vive/CMakeLists.txt
else
	echo "rviz_vive plugin repo already exists!"
	# in case it was already downloaded but the path was not replaced...
	sed -i "30s|.*|set(OPENVR \"${ROOTPATH}\/${CATKIN}\/${SRC}\/openvr\")|" \
			rviz_vive/CMakeLists.txt
fi


# NVIDIA Drivers
## install drivers if not already installed

DRIVER=$(sudo ubuntu-drivers devices | grep "recommended" | awk '{print $3}')

dpkg -s $DRIVER &> /dev/null

if [ $? -eq 0 ]; then
    echo "Proper NVIDIA graphics card drivers are already installed!"
else
    echo "NVIDIA graphics card drivers are NOT installed! Installing now."
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt update
	sudo apt install $DRIVER
fi

cd ../
echo "Rviz Vive Plugin installed, now building catkin workspace."
echo `pwd`
echo $ROOTPATH/$CATKIN/$SRC/openvr

catkin_make
