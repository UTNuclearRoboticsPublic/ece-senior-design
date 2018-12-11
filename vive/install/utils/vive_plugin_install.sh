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
MYFILENAME="vive_plugin_install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

#MYPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BUILD="build"
SRC="src"
DEST="rviz_vive"
#CONFIG="config"
OGREFILES="/usr/include/OGRE/RenderSystems/GL/GL/*"
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
if ! dpkg -s libglu1-mesa-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libglu1-mesa-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing libglu1-mesa-dev." >> "$LOGFILE"
    sudo apt-get libglu1-mesa-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed libglu1-mesa-dev." >> "$LOGFILE"
fi

if ! dpkg -s freeglut3-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] freeglut3-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing freeglut3-dev." >> "$LOGFILE"
    sudo apt-get freeglut3-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed freeglut3-dev." >> "$LOGFILE"
fi

if ! dpkg -s mesa-common-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] mesa-common-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing mesa-common-dev." >> "$LOGFILE"
    sudo apt-get mesa-common-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed mesa-common-dev." >> "$LOGFILE"
fi

if ! dpkg -s libogre-1.9-dev &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] libogre-1.9-dev is already installed, skipping installation." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] Installing libogre-1.9-dev." >> "$LOGFILE"
    sudo apt-get libogre-1.9-dev &&
    echo "[INFO: $MYFILENAME $LINENO] Installed libogre-1.9-dev." >> "$LOGFILE"
fi

echo "[INFO: $MYFILENAME $LINENO] Copying $OGREFILES to $OGREDEST1" >> "$LOGFILE"
if ! sudo cp "$OGREFILES" "$OGREDEST1"
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy $OGREFILES to $OGREDEST1 failed" >> "$LOGFILE"
fi

echo "[INFO: $MYFILENAME $LINENO] Copying $OGREFILES to $OGREDEST2" >> "$LOGFILE"
if ! sudo cp "$OGREFILES" "$OGREDEST2"
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy $OGREFILES to $OGREDEST1 failed" >> "$LOGFILE"
fi

#####################################################################
# Install Steam
#####################################################################
if ! dpkg -s steam &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] Steam is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Updating package lists with 'apt-get update'." >> "$LOGFILE"
	sudo add-apt-repository multiverse
	sudo apt update &> /dev/null
    echo "[INFO: $MYFILENAME $LINENO] Installing Steam." >> "$LOGFILE"
	sudo apt install steam
	echo "[INFO: $MYFILENAME $LINENO] Steam is installed and being pushed to the background to update." >> "$LOGFILE"
	bash steam &> /dev/null &
	disown
fi

#####################################################################
# Install OpenVR
#####################################################################
if [ ! -d "$CATKIN"/"$SRC"/openvr ];
then
	echo "[INFO: $MYFILENAME $LINENO] Cannot find OpenVR in $CATKIN/$SRC. Cloning now." >> "$LOGFILE"
	git clone https://github.com/ValveSoftware/openvr.git "$CATKIN"/"$SRC"/openvr &&
	echo "[INFO: $MYFILENAME $LINENO] OpenVR cloned to $CATKIN/$SRC/openvr." >> "$LOGFILE"
else
    echo "[INFO: $MYFILENAME $LINENO] OpenVR is already cloned, skipping installation." >> "$LOGFILE"
fi

echo "[INFO: $MYFILENAME $LINENO] Attemting to make OpenVR." >> "$LOGFILE"
cd "$CATKIN"/"$SRC"/openvr || exit
if ! cmake . >> "$LOGFILE" 2>&1
then
    echo "[ERROR: $MYFILENAME $LINENO] Command 'cmake .' in $PWD failed." >> "$LOGFILE"
fi
if ! make >> "$LOGFILE" 2>&1
then
    echo "[ERROR: $MYFILENAME $LINENO] Command 'make' in $PWD failed." >> "$LOGFILE"
fi
cd - || exit > /dev/null

#####################################################################
# Install Vive Plug-in
#####################################################################
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ];
then
    echo "[INFO: $MYFILENAME $LINENO] Cannot find $DEST in $CATKIN/$SRC. Cloning now." >> "$LOGFILE"
    git clone https://github.com/btandersen383/rviz_vive "$CATKIN"/"$SRC"/"$DEST"/
    echo "[INFO: $MYFILENAME $LINENO] $DEST cloned to $CATKIN/$SRC/$DEST" >> "$LOGFILE"
    
    # If CATKIN is not absolute, make absolute for CMake file
    if [[ $CATKIN != '/'* ]];
    then
        CATKIN=$PWD/$CATKIN
    fi

    # Edit the CMakeList to point to OpenVR
    LINETOEDIT=30
    CMAKELISTS="$CATKIN"/"$SRC"/"$DEST"/CMakeLists.txt
    LINEBEFORE=$(head -"$LINETOEDIT" "$CMAKELISTS" | tail -1)
	sed -i "30s|.*|set(OPENVR \"${CATKIN}\/${SRC}\/openvr\")|" \
			"$CMAKELISTS"
    LINEAFTER=$(head -"$LINETOEDIT" "$CMAKELISTS" | tail -1)
    echo "[INFO: $MYFILENAME $LINENO] $CMAKELISTS for $DEST edited. Line $LINETOEDIT changed from $LINEBEFORE to $LINEAFTER">> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Vive plug-in is already cloned, skipping installation." >> "$LOGFILE"
fi

# TODO
# Move config file to proper location
#cp $MYPATH/$CONFIG/$RVIZ_CONFIG_FILE $CATKIN/$SRC/$DEST/$RVIZ_CONFIG/$RVIZ_CONFIG_FILE

#####################################################################
# Install Nvidia Drivers
#####################################################################
DRIVER=$(sudo ubuntu-drivers devices | grep "recommended" | awk '{print $3}')
if ! dpkg -s "$DRIVER" &> /dev/null
then
    echo "[INFO: $MYFILENAME $LINENO] The recommended graphics drivers ($DRIVER) are already installed." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Updating package lists with 'apt-get update'." >> "$LOGFILE"
	sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update &> /dev/null
	echo "[INFO: $MYFILENAME $LINENO] Installing $DRIVER" >> "$LOGFILE"
	sudo apt install "$DRIVER" &&
	echo "[INFO: $MYFILENAME $LINENO] Installed $DRIVER" >> "$LOGFILE"
fi
