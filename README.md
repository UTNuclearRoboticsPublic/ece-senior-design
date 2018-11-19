
# Overview

Provide end to end handling of data for live streaming video to the HTC Vive headset.
* [Overview](#overview)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Extras](#extras)

## Members

This repository contains code used by the ECE Senior Design team composed of: Beathen Andersen, Kate Baumli, Daniel Diamont, Bryce Fuller, Caleb Johnson, John Sigmon. The team is advised by Dr. Mitchell Pyror, head of the University of Texas Nuclear Robotics Group.

## Description

TODO

## This document

This README contains instructions for installation and usage of the project. Directions for complete clean installation are given as well as how to install each subsystem individually. All dependencies for each section are described, **read carefully** as we may install software that will replace what you are currently using. Make sure your system already meets the requirements listed below before trying to install and run this project.

## Contents

```tree
	ece-senior-design
	├── install
	│    ├── config
	│    │    ├── dual-cam.launch
	│    │    ├── single-cam.launch
	│    │    ├── vive.launch
	│    │    └── vive_launch_config.rviz
	│    ├── ros-install.sh
	│    ├── textured-sphere-install.sh
	│    ├── usb-cam-install.sh
	│    └── vive-plugin-install.sh
	├── osvr
	│    ├── README.md
	│    └── osvr-setup.sh
	├── vive
	│    ├── README.md
	│    ├── modified_vive_display.cpp
	│    └── troubleshooting_install.md
	├── utils
	│    ├── find_dev_cam_name.sh
	│    └── kill_roscore.sh
	├── clean-install.sh
	├── kill_launch.sh
	├── single_node_launch.sh
	├── requirements
	└── README.md
```

# Requirements

* Ubuntu 16.04
* Nvidia GPU
* g++ 4.9
* ROS Kinetic
* OGRE
* Qt 5.x
* GLEW 1.11+
* SteamVR
* OpenVR
* NVIDIA Driver

# Installation

Clone the repository.

```bash
$ git clone https://github.com/UTNuclearRoboticsPublic/ece-senior-design.git
```

Move into the cloned repository.

```bash
$ cd ece-senior-design
```

From here, you have two options:
1. [Perform the clean installation](#clean-installation)
2. [Perform one or more individual installations](#individual-installations)

## Clean Installation

For a clean installation, run

```bash
$ bash clean-install.sh <relative/path/to/catkin-ws>
```
**TODO List all dependecies installed here**

Be prepared as there are multiple prompts that require answers. Almost all dependencies will be installed. Any dependencies already installed will not be changed. 

Once the installations script completes, start steam and log into your account. Plug in the HTC Vive and Steam will automatically prompt to install SteamVR. This should be the last time you have to mess with steam. **TODO** Add directions to take steam offline

## Individual Installations

For detailed instructions on how to install individually, navigate to the install directory. There are individual scripts for ROS Kinetic, Textured Sphere stiching, USB Cam, and the Vive Plugin.

# Usage

There will be two hardware configurations supported. Single node and double node. **Double node is not yet supported.** Before attempting to start the system, make sure all hardware is properly connected to either the laptop or the desktop nodes.

## Single Node Launch

To launch the system from a single node, run
```bash
$ bash single_node_launch.sh <relative/path/to/catkin-ws>
```
This will start all the necessary processes: roscore, steam, and rviz. Once rviz is running and steam has connection to both base stations and the headset, add vive_display in rviz.

## Double Node Launch

**Not yet supported**

## Kill launch

To close **all** project related processes, run

```bash
$ bash kill_launch.sh
```

**Warning:** this will also close the roscore. 

# Extras

## Updating the documentation

To update any README's, just open the .md file in your favorite text editor. You can render markdown files in your local browser to ensure they look the way you want by activating your environment, and running

```bash
$ grip <readme name>
```

This returns a link to a localhost address where you can view the rendered markdown file.