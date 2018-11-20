#!/bin/bash

# Authors: Daniel Diamont and John Sigmon
# Last Modified: 10-28-2018

# Purpose:
# 	This script installs the following packages if they are not already installed:
#		* ros-kinetic-desktop-full
#		* python-rosinstall
#		* python-rosinstall-generator
#		* python-wstool
#		* build-essential

echo " "
echo " Updating package lists with 'apt-get update'. Please wait..."
echo " "
sudo apt-get update &> /dev/null

# Install ros-kinetic-desktop-full package if not already installed.
dpkg -s ros-kinetic-desktop-full &> /dev/null

if [ $? -eq 0 ]; then
    echo "ROS Kinetic is already installed!"
else
    echo "ROS Kinetic is NOT installed. Installing ROS Kinetic now!"
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

	sudo apt-key adv \
  		--keyserver hkp://ha.pool.sks-keyservers.net:80 \
  		--recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
	
	echo " "
	echo "Updating package lists with 'apt-get update'. Please wait..."
	echo " "
	sudo apt-get update &> /dev/null
	sudo apt-get install ros-kinetic-desktop-full
	sudo rosdep init
	rosdep update
	echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
	source ~/.bashrc
fi

# Install python-rosinstall if not already installed
dpkg -s python-rosinstall &> /dev/null

if [ $? -eq 0 ]; then
    echo "python-rosinstall is already installed!"
else
    echo "python-rosinstall is NOT installed. Installing python-rosinstall now!"
	sudo apt-get install python-rosinstall
fi


# Install python-rosinstall-generator if not already installed
dpkg -s python-rosinstall-generator &> /dev/null

if [ $? -eq 0 ]; then
    echo "python-rosinstall-generator is already installed!"
else
    echo "python-rosinstall-generator is NOT installed. Installing python-rosinstall-generator now!"
	sudo apt-get install python-rosinstall-generator
fi

# Install python-wstool if not already installed
dpkg -s python-wstool &> /dev/null

if [ $? -eq 0 ]; then
    echo "python-wstool is already installed!"
else
    echo "python-wstool is NOT installed. Installing python-wstool now!"
	sudo apt-get install python-wstool
fi

# Install build-essential if not already installed
dpkg -s build-essential &> /dev/null

if [ $? -eq 0 ]; then
    echo "build-essential is already installed!"
else
    echo "build-essential is NOT installed. Installing build-essential now!"
	sudo apt-get install build-essential
fi


echo "ROS setup script complete!"
