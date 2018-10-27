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
sudo add-apt-repository ppa:ogre-team/ogre
sudo apt-get update
sudo apt-get install libogre-dev

# Install Steam
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

# do not know if we need this...
#export QT_SELECT=5

# also don't know if we need this (maybe for running OpenVR samples??)
# Install g++ version 4.9
# sudo apt-get install g++-4.9

# OpenVR Install
cd $SRC 
git clone https://github.com/ValveSoftware/openvr.git

# Don't know if we need this (also for maybe running openvr samples
# Andre Gilerson said he never had to rebuild openVR binaries... just use included
#cd openvr/samples/
#mkdir build
#cd build
#cmake ..
#CXX=g++-4.9 cmake ../
#make

# Vive Plugin Install
git clone https://github.com/AndreGilerson/rviz_vive.git
sed -i '30s/.*/set(OPENVR "${ROOTPATH}/${CATKIN}/${SRC}/openvr")/' CMakeLists.txt
cd ../

### NVIDIA Drivers
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
DRIVER=$(sudo ubuntu-drivers devices | grep "recommended" | awk '{print $3}')
sudo apt install $DRIVER

echo "Rviz Vive Plugin installed, now building catkin workspace."
catkin_make
