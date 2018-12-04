#!/usr/bin/env bash
#
# Authors: Daniel Diamont and John Sigmon
# Last Modified: 11-18-2018
#
# Purpose:
# 	This script installs the following packages if they are not already installed:
#		* ros-kinetic-desktop-full
#		* python-rosinstall
#		* python-rosinstall-generator
#		* python-wstool
#		* build-essential

#####################################################################
# Parse args
#####################################################################
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -h|--help)
  echo "Usage: ros_install.sh [-l|--logfile logfile]"
	exit 1
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
# Configure log
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="ros_install.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

#####################################################################
# Force update
#####################################################################
echo "[INFO: $MYFILENAME $LINENO] Updating package lists with 'apt-get update'." >> "$LOGFILE"
sudo apt-get update &> /dev/null
echo "[INFO: $MYFILENAME $LINENO] Apt-get successful." >> "$LOGFILE"

#####################################################################
# Install ROS-Kinetic and dependencies
#####################################################################
dpkg -s ros-kinetic-desktop-full &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO] ros-kinetic-desktop-full is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Installing ." >> "$LOGFILE"
    sudo sh -c "echo "deb http://packages.ros.org/ros/ubuntu "$(lsb_release -sc)" main" > /etc/apt/sources.list.d/ros-latest.list"
	sudo apt-key adv \
  		--keyserver hkp://ha.pool.sks-keyservers.net:80 \
  		--recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
    echo "[INFO: $MYFILENAME $LINENO] Updating package lists with 'apt-get update'." >> "$LOGFILE"
	sudo apt-get update &> /dev/null
    echo "[INFO: $MYFILENAME $LINENO] Apt-get successful." >> "$LOGFILE"
	sudo apt-get install ros-kinetic-desktop-full
	sudo rosdep init
	rosdep update
	echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
	source ~/.bashrc
	echo "[INFO: $MYFILENAME $LINENO] Installed ros-kinetic-desktop-full." >> "$LOGFILE"
fi

dpkg -s python-rosinstall &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO] python-rosinstall  is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Installing python-rosinstall ." >> "$LOGFILE"
	sudo apt-get install python-rosinstall
	echo "[INFO: $MYFILENAME $LINENO] Installed python-rosinstall ." >> "$LOGFILE"
fi

dpkg -s python-rosinstall-generator &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO] python-rosinstall-generator  is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Installing python-rosinstall-generator ." >> "$LOGFILE"
	sudo apt-get install python-rosinstall-generator
	echo "[INFO: $MYFILENAME $LINENO] Installed python-rosinstall-generator ." >> "$LOGFILE"
fi

dpkg -s python-wstool &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO] python-wstool  is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Installing python-wstool ." >> "$LOGFILE"
	sudo apt-get install python-wstool
	echo "[INFO: $MYFILENAME $LINENO] Installed python-wstool ." >> "$LOGFILE"
fi

dpkg -s build-essential &> /dev/null
if [ $? -eq 0 ]; then
    echo "[INFO: $MYFILENAME $LINENO] build-essential  is already installed, skipping installation." >> "$LOGFILE"
else
	echo "[INFO: $MYFILENAME $LINENO] Installing build-essential ." >> "$LOGFILE"
	sudo apt-get install build-essential
	echo "[INFO: $MYFILENAME $LINENO] Installed build-essential ." >> "$LOGFILE"
fi
