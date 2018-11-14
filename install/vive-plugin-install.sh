#!/usr/bin/env bash

# Authors: John Sigmon and Daniel Diamont
# Last modified 11/5/18

# Check that user passed in catkin workspace path
if [ $# -eq 1 ]; 
then
	CATKIN_RELATIVE=${1%/}
else
	echo "Usage: vive-plugin-install.sh <path to catkin workspace>"
	exit 1
fi

FILENAME="vive-plugin-install.sh"
MYFULLPATH=$(locate $FILENAME)	# Finds all copies of this file!!!!!!!
MYPATH=${MYFULLPATH%/*}
ROOT=$PWD
#CATKIN=$ROOT/$CATKIN_RELATIVE	
CATKIN=$CATKIN_RELATIVE	
BUILD="build"
SRC="src"
DEST="rviz_vive"
INSTALL="install"
CONFIG="config"
LAUNCH="launch"
RVIZ_CONFIG_FILE="vive_launch_config.rviz"
RVIZ_CONFIG="rviz_cfg" 

# Create catkin workspace directory if it does not already exist
#cd "$CATKIN"
mkdir -p "$CATKIN"/"$BUILD"
mkdir -p "$CATKIN"/"$SRC"

# Install OpenGL if not already installed
dpkg -s libglu1-mesa-dev &> /dev/null

if [ $? -eq 0 ]; then
    echo "OpenGL libglu1-mesa-dev is already installed!"
else
    echo "OpenGL libglu1-mesa-dev is NOT installed! Installing now."
	sudo apt-get libglu1-mesa-dev
fi

dpkg -s freeglut3-dev &> /dev/null

if [ $? -eq 0 ]; then
    echo "OpenGL freeglut3-dev ibglu1-mesa-dev is already installed!"
else
    echo "OpenGL freeglut3-dev ibglu1-mesa-dev is NOT installed! Installing now."
	sudo apt-get freeglut3-dev
fi

	
dpkg -s mesa-common-dev &> /dev/null

if [ $? -eq 0 ]; then
    echo "mesa-common-dev is already installed!"
else
    echo "OpenGL mesa-common-dev is NOT installed! Installing now."
	sudo apt-get mesa-common-dev
fi

# Install OGRE
## check if installed
dpkg -s libogre-1.9-dev &> /dev/null

if [ $? -eq 0 ]; then
    echo "OGRE is already installed!"
else
    echo "OGRE  is NOT installed!"
	sudo apt-get install libogre-1.9-dev
fi

sudo cp /usr/include/OGRE/RenderSystems/GL/GL/* /usr/include/OGRE/RenderSystems/GL/
sudo cp /usr/include/OGRE/RenderSystems/GL/GL/* /usr/include/GL/

# Install Steam
## check if steam is installed
dpkg -s steam &> /dev/null

if [ $? -eq 0 ]; then
    echo "Steam is already installed!"
else
    echo "Steam is NOT installed. Installing now!"
#	sudo apt-key adv \
#  		--keyserver keyserver.ubuntu.com \
#  		--recv-keys F24AEA9FB05498B7
#	REPO="deb http://repo.steampowered.com/steam/ $(lsb_release -cs) steam"
#	echo "${REPO}" > /tmp/steam.list
#	sudo mv /tmp/steam.list /etc/apt/sources.list.d/ && sudo apt-get update
#	sudo apt-get install -y steam

#	# Steam Installer is broken... these are the steps that the installer tries to do
#	mv ~/.steam/steam/* ~/.local/share/Steam/
#	rmdir ~/.steam/steam
#	ln -s ../.local/share/Steam ~/.steam/steam
#	rm -rf ~/.steam/bin
	
	# Easier way to install steam
	sudo add-apt-repository multiverse
	echo " "
	echo " Updating package lists with 'apt-get update'. Please wait..."
	sudo apt update &> /dev/null
	sudo apt install steam
	echo " "
	echo "Steam will now update itself in the background"
	echo " "
	bash steam &> /dev/null &
	disown
fi


# do not know if we need this...
#export QT_SELECT=5

# also don't know if we need this (maybe for running OpenVR samples??)
# Install g++ version 4.9
# sudo apt-get install g++-4.9

# OpenVR Install
#cd $SRC
# Install OpenVR repo if directory 'openvr' does not exist
if [ ! -d "$CATKIN"/"$SRC"/"openvr" ]; then
	echo "OpenVR repo does not exist. Pulling OpenVR repository!" 
	git clone https://github.com/ValveSoftware/openvr.git $CATKIN/$SRC/"openvr"
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
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ]; then
	echo "rviz_vive plugin repo does not exist. Pulling rviz_vive repository!"
	git clone https://github.com/btandersen383/rviz_vive "$CATKIN"/"$SRC"/"$DEST"/
	sed -i "30s|.*|set(OPENVR \"${ROOT}\/${CATKIN}\/${SRC}\/openvr\")|" \
			"$CATKIN"/"$SRC"/"$DEST"/CMakeLists.txt
else
	echo "rviz_vive plugin repo already exists!"
	# in case it was already downloaded but the path was not replaced...
	sed -i "30s|.*|set(OPENVR \"${ROOT}\/${CATKIN}\/${SRC}\/openvr\")|" \
			"$CATKIN"/"$SRC"/"$DEST"/CMakeLists.txt
fi

# Move config file to proper location 
#cp $MYPATH/$CONFIG/$RVIZ_CONFIG_FILE $CATKIN/$SRC/$DEST/$RVIZ_CONFIG/$RVIZ_CONFIG_FILE

# NVIDIA Drivers
## install drivers if not already installed

DRIVER=$(sudo ubuntu-drivers devices | grep "recommended" | awk '{print $3}')

dpkg -s $DRIVER &> /dev/null

if [ $? -eq 0 ]; then
    echo "Proper NVIDIA graphics card drivers are already installed!"
else
    echo "NVIDIA graphics card drivers are NOT installed! Installing now."
	sudo add-apt-repository ppa:graphics-drivers/ppa
	echo " Updating package lists with 'apt-get update'. Please wait..."
	sudo apt update &> /dev/null
	sudo apt install $DRIVER
fi

#cd $ROOT

echo "Rviz Vive Plugin installed."
