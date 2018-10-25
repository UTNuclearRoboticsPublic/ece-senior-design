# Rviz and Vive Installation

## Introduction
## System Requirements
* Ubuntu 16.04
* g++ 4.9
* ROS #TODO
* NVIDIA Drivers

## Installation Steps

This section is broken down into the following sections:

* OGRE (pending)
* Qt 5.x (pending)
* GLEW 1.11+ (pending)

* usb_cam (pending)
* SteamVR
* OpenVR and rviz_vive plugin
* NVIDIA Drivers

### OGRE Intallation

```bash
sudo add-apt-repository ppa:ogre-team/ogre
sudo apt-get update
sudo apt-get install libogre-dev
```

### GLEW
`wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz/`
`tar -xvzf glew-2.1.0.tgz`
`cd glew-2.1.0`
`make`


### Install Qt 5.x
https://www.lucidar.me/en/dev-c-cpp/how-to-install-qt-creator-on-ubuntu-16-04/


### Setup usb_cam

```bash
cd /catkin-ws/src
git clone https://github.com/ros-drivers/usb_cam.git
cd $CATKIN/
catkin_make
```

### SteamVR

1. Download Steam

```bash
sudo apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys F24AEA9FB05498B7
REPO="deb http://repo.steampowered.com/steam/ $(lsb_release -cs) steam"
echo "${REPO}" > /tmp/steam.list
sudo mv /tmp/steam.list /etc/apt/sources.list.d/ && sudo apt-get update
sudo apt-get install -y steam
```

2. Execute the following command:

```bash
mv ~/.steam/steam/* ~/.local/share/Steam/
rmdir ~/.steam/steam
ln -s ../.local/share/Steam ~/.steam/steam
rm -rf ~/.steam/bin
```

### OpenVR and rviz_vive plugin from [Andre Gilerson](https://github.com/AndreGilerson/rviz_vive)

1. Ensure that QT5 dependency for OpenVR is satisfied for later build step with gcc++
    
    ```bash
    export QT_SELECT=5
    ```
2. git clone OpenVR release v1.0.16
Decide what to do with g++ req, how to notify user
    * Build OpenVR src code (at ~/openvr/src/) with:
		```
		sudo apt-get install g++-4.9 
        git clone https://github.com/ValveSoftware/openvr.git
        cd openvr/samples/
        mkdir build
        cd build
        CXX=g++-4.9 cmake ../
        make
		```

3. Follow RVIZ Vive Plugin Installation procedure on [readme](https://github.com/AndreGilerson/rviz_vive)
	* Change OpenVR path in CMakeLists.txt to point to openVR installation
		i.e. replace line 30 of rviz_vive/CMakeLists.txt to say
		```
		set(OPENVR "~${HOME}/openvr")
		```
	* Build catkin workspace with ``` catkin_make ``` command at root of catkin worspace. 

### NVIDIA Drivers

Update drivers as follows if using an NVIDIA graphics card.

```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
DRIVER=$(sudo ubuntu-drivers devices | grep "recommended" | awk '{print $3}'
sudo apt install $DRIVER
```
```
#DRIVERNUM=$(echo $DRIVER | cut -d- -f2)

```


Then reboot the PC for the changes to take effect.

## How to Run

### Hardware Setup

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

#### NVIDIA Graphics Driver Config

1. Check that we are actually using the NVIDIA graphics card.
    * Check Ubuntu Settings > Details -- should see NVIDIA card listed in "Graphics"

    * Check NVIDIA card config through terminal using
        ```
        $ nvidia-settings
        ```

    * A good check is to play a video or do something a bit graphics compute intensive and watch the NVIDA card GPU usage % go up and down. If the usage % remains pretty stable, it may be a sign that the PC may be using the integrated GPU instead. Since SteamVR and the Vive require that a discrete GPU is used, make sure that this is working first.

### Software Setup

#### usb_cam launch configuration

1. Check that the usb cameras are detected by the linux OS and are ready to stream.
    From the linux terminal:

    ```
    $ cd /dev/
    $ ls | grep video
    ```
    If the PC has an internal webcam, this will likely be video0.
    The Vive headset has its own camera, so the vive cam plus the two usb cameras will make up any combination of video1, 2, and 3.
    If more video devices are plugged in, these numbers will vary, so make sure that you narrow down what device corresponds to each ID.

2. Edit dual_cam.launch to specify the usb camera device numbers:
    Under the *param name* tag, change the value to point to the correct device number. Do this for each of the cameras.

    Example: <param name="video_device" value="/dev/video3" />

#### rviz_textured_sphere configuration

1. Edit demo.launch file to run steam server .sh file as launch-prefix param so we can roslaunch it

    Make sure that *demo.launch* in rviz_textured_sphere/launch/ consists of the following code:
    ```
    <?xml version="1.0"?>
    <launch>
      <node pkg="rviz" type="rviz" name="rviz"
        args="-l -d $(find rviz_textured_sphere)/rviz_cfg/rviz_textured_sphere.rviz"
        output="screen"
        launch-prefix="${HOME}/.steam/steam/ubuntu12_32/steam-runtime/run.sh" />
    </launch>
    ```

#### ROS Environment Setup

1. Open a terminal and start the roscore.

    ```
    $ roscore
    ```

2. Open another terminal and set up the ROS Environment for the cameras, Vive, and RVIZ with the following step:

    At the root of your catkin workspace
    ```
    $ source devel/setup.bash
    ```

3. Launch the cameras by running:
    ```
    $ roslaunch usb_cam dual_cam.launch
    ```
    Check that you are receiving a video feed from both of the cameras.

#### SteamVR Setup
HIGHLIGHT!!!!!!!!!!!
looking for command line way to run
is it necessary after runing steam runtime in rviz launch file
look at https://github.com/ValveSoftware/SteamVR-for-Linux/blob/master/README.md under runtime requirements

1. Open Steam using the Ubuntu Dashboard.

2. Search for SteamVR and click "Play".

3. (add more detail) Select SteamVR beta.

4. Make sure that the headset can "see" both of the base stations.

### RVIZ / Vive Launch

1. Open another terminal and set up the ROS Environment for the cameras, Vive, and RVIZ with the following step:

    At the root of your catkin workspace
    ```
    $ source devel/setup.bash
    ```
2. Start RVIZ with:

    ```
    roslaunch rviz_textured_sphere demo.launch
    ```

3. Add vive display plugin once in RVIZ. This should cause the stream to render in the HTC VIVE headset.


