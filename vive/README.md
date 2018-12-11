# Video Display on the Vive

* [Introduction](#introduction)
* [Contents](#contents)
* [Usage](#usage)
* [Installation](#installation)
* [Software](#software)
* [Hardware](#hardware)

## Introduction
This README contains instructions for installation and usage of the project. Directions for complete clean installation are given as well as how to install each subsystem individually. All dependencies for each section are described, **read carefully** as we may install software that will replace what you are currently using. Make sure your system already meets the requirements listed below before trying to install and run this project.

([Imgur](https://i.imgur.com/Uyfj7dN.png) "System Diagram")

---

## Contents
```
vive
 ├── install/
 │    ├── utils/
 │    │    ├── config/
 │    │    ├── ros-install.sh
 │    │    ├── textured-sphere-install.sh
 │    │    ├── usb-cam-install.sh
 │    │    └── vive-plugin-install.sh
 │    └── install.sh
 ├── utils/
 │    └── find_cam_dev_name.sh
 ├── README.md
 ├── single_node_launch.sh
 ├── kill_launch.sh
 └── other_launches.sh
```

---

## Usage
There are two hardware configurations supported. Single node and dual node. **Dual node is not yet supported.** Before attempting to start the system, make sure all hardware is properly connected to the laptop and/or the desktop node(s).

### Single Node Launch
To launch the system on a sigle computer, first plug in the headset and cameras. Then run the following:
```bash
bash single_node_launch.sh -c <path to catkin workspace> -l <optional path to log file>
```

### Dual Node Launch
To launch the system on a robot-base configuration, run the following on the robot module:
```bash
bash robot_launch.sh -c <path to catkin workspace>
```
Then run the following on the base module:
```bash
bash base_launch.sh -c <path to catkin workspace>
```

### Kill Launch
To kill all processes associated with a launch, including the roscore, run the following:
```bash
bash kill_launch.sh
```

---

## Installation

Navigate to `install/` and run `install.sh`.

```bash
cd install
bash -i install.sh <path to catkin workspace>
```

You must make the catkin workspace after intallation.

```bash
cd <catkin workspace>
catkin build
```

Note that `catkin_make` can also be used to build your workspace, however the two methods cannot be combined. See [https://catkin-tools.readthedocs.io/en/latest/migration.html](https://catkin-tools.readthedocs.io/en/latest/migration.html) for more details.

Further installation details can be found inside [`install/`](install)

---

## Software

### Software Requirements
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

---

## Hardware

### Hardware Requirements
* Nvidia GPU
* Vive Headset
* Wide view cameras

#### Vive Headset

1. Ensure that HDMI, USB, and power are connected to the Vive Link Box.

2. Connect the link box HDMI cable and USB cable to the PC.

#### Vive Base Stations

1. Set up Base Stations in the following configuration to encompass the play area.
```
 BS ------------
 |              |
 |              |
 |              |
 |   play area  |
 |              |
 |              |
 |              |
  ------------ BS
```
    The base stations should have a clear line of sight to each other.

2. Connect the base stations with the SYNC cable.

3. Make sure that one of the base stations is set to **Channel A** and the other to **Channel B**. 
    It does not matter which base station is set to which channel, as long as one is set to A and the other is set to B.

#### Vive Controllers (pending)

#### USB Cameras

1. Ensure that the cameras are charged. 
    In livestream mode, the cameras discharge quickly.

2. Set up both cameras in the desired configuration (back-to-back facing away from each other)

3. Plug in the cameras to the desired USB ports.

4. Turn on the cameras by holding down the power button.
    After this, the cameras should automatically enter webcam mode.
    You can verify that they are in webcam mode by checking the LCD screen on each of the cameras, which should display an image saying it is in webcam mode.
    If they do not automatically go into webcam mode, check the integrity of the USB connection.
