#!/usr/bin/env bash
#
# Authors: John Sigmon and Daniel Diamont
# Last modified 11-18-18
# Purpose:
# This script installs the OSS plug-in for the Vive headset and SteamVR

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: vive_plugin_install.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
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
#RVIZ_CONFIG_FILE="vive_launch_config.rviz"
#RVIZ_CONFIG="rviz_cfg"

#####################################################################
# Make Catkin dirs if not there
#####################################################################
if [ ! -d "$CATKIN"/"$BUILD" ];
then
	echo "[INFO: $MYFILENAME $LINENO] Making $BUILD dir in catkin workspace at $CATKIN" >> "$LOGFILE"
    mkdir -p "$CATKIN"/"$BUILD"
fi

if [ ! -d "$CATKIN"/"$SRC" ];
then
	echo "[INFO: $MYFILENAME $LINENO] Making $SRC dir in catkin workspace at $CATKIN" >> "$LOGFILE"
    mkdir -p "$CATKIN"/"$SRC"
fi

#####################################################################
# Install dependencies
#####################################################################
if dpkg -s libglu1-mesa-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libglu1-mesa-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing libglu1-mesa-dev." >> "$LOGFILE"
    sudo apt-get libglu1-mesa-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed libglu1-mesa-dev." >> "$LOGFILE"
fi

if dpkg -s freeglut3-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] freeglut3-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing freeglut3-dev." >> "$LOGFILE"
    sudo apt-get freeglut3-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed freeglut3-dev." >> "$LOGFILE"
fi

if dpkg -s mesa-common-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] mesa-common-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing mesa-common-dev." >> "$LOGFILE"
    sudo apt-get mesa-common-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed mesa-common-dev." >> "$LOGFILE"
fi

if dpkg -s libogre-1.9-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libogre-1.9-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing libogre-1.9-dev." >> "$LOGFILE"
    sudo apt-get libogre-1.9-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed libogre-1.9-dev." >> "$LOGFILE"
fi

if dpkg -s libopenhmd0 &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libopenhmd0 is already installed, skipping installation." >> "$LOGFILE"
else 
    echo "[INFO: $MYFILENAME $LINENO] Installing libopenhmd0." >> "$LOGFILE"
    sudo add-apt-repository ppa:theonlyjoey/openhmd
    sudo apt-get update
    sudo apt-get install libopenhmd0
    echo "[INFO: $MYFILENAME $LINENO] Installed libopenhmd0." >> "$LOGFILE"
fi

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
