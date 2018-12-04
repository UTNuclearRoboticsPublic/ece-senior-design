#!/usr/bin/env bash
#
# Authors: John Sigmon and Daniel Diamont
# Last modified 11-18-18
#
# Purpose:
#	This script installs the rviz_textured_sphere plugin from the
#	UTNuclearRoboticsGroup public repository

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 2 ];
then
	echo "Usage: rviz_textured_sphere_install.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]"
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
MYFILENAME="rviz_textured_sphere_install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)"$MYFILENAME".txt"
fi

MYPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BUILD="build"
SRC="src"
DEST="rviz_textured_sphere"
INSTALL="install"
CONFIG="config"
LAUNCH="launch"
DEMOLAUNCH="demo.launch"
VIVELAUNCH="vive.launch"
#RVIZ_CONFIG="vive_launch_config.rviz"
#RVIZ_CONFIG_FOLDER="rviz_cfg"

#####################################################################
# Make Catkin dirs if not there
#####################################################################
if [ ! -d "$CATKIN"/"$BUILD" ];
then
	echo "[INFO: $MYFILENAME $LINENO] Making "$BUILD" dir in catkin workspace at "$CATKIN"" >> $LOGFILE
    mkdir -p "$CATKIN"/"$BUILD"
fi

if [ ! -d "$CATKIN"/"$SRC" ];
then
	echo "[INFO: $MYFILENAME $LINENO] Making "$SRC" dir in catkin workspace at "$CATKIN"" >> $LOGFILE
    mkdir -p "$CATKIN"/"$SRC"
fi

#####################################################################
# Install rviz textured sphere
#####################################################################
if [ ! -d "$CATKIN"/"$SRC"/"$DEST" ];
then
		echo "[INFO: $MYFILENAME $LINENO] Cannot find "$DEST" in "$CATKIN"/"$SRC". Cloning now." >> $LOGFILE
    git clone https://github.com/UTNuclearRoboticsPublic/rviz_textured_sphere.git "$CATKIN"/"$SRC"/"$DEST" &&
		echo "[INFO: $MYFILENAME $LINENO] "$DEST" cloned to "$CATKIN"/"$SRC"/"$DEST"" >> $LOGFILE
else
	  echo "[INFO: $MYFILENAME $LINENO] "$DEST" is already cloned, skipping installation." >> $LOGFILE
fi

echo "[INFO: $MYFILENAME $LINENO] Copying "$VIVELAUNCH" from "$MYPATH"/"$CONFIG"/"$VIVELAUNCH" \
	to "$CATKIN"/"$SRC"/"$DEST"/"$LAUNCH"/"$VIVELAUNCH"" >> $LOGFILE
cp "$MYPATH"/"$CONFIG"/"$VIVELAUNCH" "$CATKIN"/"$SRC"/"$DEST"/"$LAUNCH"/"$VIVELAUNCH"
if [[ $? != 0 ]];
then
    echo "[ERROR: $MYFILENAME $LINENO] Copy "$VIVELAUNCH" to "$CATKIN"/"$SRC"/"$DEST"/"$LAUNCH"/"$VIVELAUNCH" failed." >> $LOGFILE
fi

LINETOEDIT=8
PATHTOLAUNCH="$CATKIN"/"$SRC"/"$DEST"/"$LAUNCH"/"$VIVELAUNCH"
LINEBEFORE=$(head -"$LINETOEDIT" "$PATHTOLAUNCH" | tail -1)
    sed -i "8s|.*|        launch-prefix=\"${HOME}/.steam/ubuntu12_32/steam-runtime/run.sh\" />|" "$CATKIN"/"$SRC"/"$DEST"/"$LAUNCH"/"$VIVELAUNCH"
LINEAFTER=$(head -"$LINETOEDIT" "$PATHTOLAUNCH" | tail -1)
echo "[INFO: $MYFILENAME $LINENO] "$SPHERELAUNCH" Line "$LINETOEDIT" changed from "$LINEBEFORE" to "$LINEAFTER"">> $LOGFILE

# Move rviz config file to proper location
#cp $MYPATH/$CONFIG/$RVIZ_CONFIG $CATKIN/$SRC/$DEST/$RVIZ_CONFIG_FOLDER/$RVIZ_CONFIG
