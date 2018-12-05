# Video Display on the Vive

---

## Introduction

TODO
---

## Usage

To launch the system on a sigle computer, first plug in the headset and cameras. Then run the following:

```bash
bash single_node_launch.sh -c <path to catkin workspace> -l <optional path to log file>
```

To kill all processes associated with a launch, run the following:

```bash
bash kill_launch.sh
```

---

## Installation

---

### Software 

## System Requirements
* Ubuntu 16.04
TODO

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

Further installation details can be found inside `install/`

---

### Hardware

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
