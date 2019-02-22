#!/usr/bin/env bash
#
# Authors: John Sigmon, Daniel Diamont, Beathan Andersen, Kate Baumli
# Last modified 02/04/2019
# Purpose:
# This script installs tbe openHMD plugin

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: openhmd_plugin_install.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
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
MYFILENAME="openhmd_plugin_install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

#MYPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BUILD="build"
SRC="src"
DEST="rviz_openhmd"
#CONFIG="config"
OGREFILES="/usr/include/OGRE/RenderSystems/GL/GL/."
OGREDEST1="/usr/include/OGRE/RenderSystems/GL/"
OGREDEST2="/usr/include/GL/"
OPENHMDRULES="/config/50-openhmd.rules"
RULESDEST="/etc/udev/rules"
#RVIZ_CONFIG_FILE="vive_launch_config.rviz"
#RVIZ_CONFIG="rviz_cfg"

#####################################################################
# Make Catkin dirs if not there
#####################################################################
mkdir -p "$CATKIN"/"$BUILD"
mkdir -p "$CATKIN"/"$SRC"

#####################################################################
# Install dependencies
#####################################################################
sudo apt-get -y install libglu1-mesa-dev \
        freeglut3-dev \
        mesa-common-dev \
        libogre-1.9-dev \
        libudev-dev \
        libusb-1.0-0-dev \
        libfox-1.6-dev \
        autotools-dev \
        autoconf \
        automake \
        libtool \
        libsdl2-dev \
        libxmu-dev \
        libxi-dev \
        libgl-dev \
        libglew1.5-dev \
        libglew-dev \
        libglewmx1.5-dev \
        libglewmx-dev \
        libhidapi-dev \
        freeglut3-dev 2>&1 | tee -a "$LOGFILE"

#########################################
# TODO: check for install method
#########################################
# OpenHMD
echo "[INFO: $MYFILENAME $LINENO] Installing libopenhmd-dev." >> "$LOGFILE"
git clone https://github.com/OpenHMD/OpenHMD.git ~/OpenHMD
cd ~/OpenHMD || exit 1
git checkout 4ca169b49ab4ea4bee2a8ea519d9ba8dcf662bd5
cmake .
make
cd - || exit 1

#########################################
# TODO: cp is not working
#########################################
# Add usb rules
echo "[INFO: $MYFILENAME $LINENO] Copying $OPENHMDRULES to $RULESDEST" >> "$LOGFILE"
# shellcheck disable=SC2024
if ! sudo cp -a "$OPENHMDRULES" "$RULESDEST" &>> "$LOGFILE"
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy $OPENHMDRULES to $RULESDEST failed" >> "$LOGFILE"
fi
udevadm control --reload-rules

echo "[INFO: $MYFILENAME $LINENO] Copying $OGREFILES to $OGREDEST1" >> "$LOGFILE"
# shellcheck disable=SC2024
if ! sudo cp -a "$OGREFILES" "$OGREDEST1" &>> "$LOGFILE"
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy $OGREFILES to $OGREDEST1 failed" >> "$LOGFILE"
fi

echo "[INFO: $MYFILENAME $LINENO] Copying $OGREFILES to $OGREDEST2" >> "$LOGFILE"
# shellcheck disable=SC2024
if ! sudo cp -a "$OGREFILES" "$OGREDEST2" &>> "$LOGFILE"
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy $OGREFILES to $OGREDEST1 failed" >> "$LOGFILE"
fi

#####################################################################
# Install Vive Plug-in
#####################################################################
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ];
then
    echo "[INFO: $MYFILENAME $LINENO] Cannot find $DEST in $CATKIN/$SRC. Cloning now." >> "$LOGFILE"
    git clone https://github.com/btandersen383/rviz_openhmd "$CATKIN"/"$SRC"/"$DEST"/
    echo "[INFO: $MYFILENAME $LINENO] $DEST cloned to $CATKIN/$SRC/$DEST" >> "$LOGFILE"
    
    # If CATKIN is not absolute, make absolute for CMake file
    if [[ $CATKIN != '/'* ]];
    then
        CATKIN=$PWD/$CATKIN
    fi
else
	echo "[INFO: $MYFILENAME $LINENO] Vive plug-in is already cloned, skipping installation." >> "$LOGFILE"
fi

# TODO
# Move config file to proper location
#cp $MYPATH/$CONFIG/$RVIZ_CONFIG_FILE $CATKIN/$SRC/$DEST/$RVIZ_CONFIG/$RVIZ_CONFIG_FILE