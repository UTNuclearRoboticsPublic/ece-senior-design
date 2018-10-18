# Rviz and Vive Setup
	By Daniel Diamont

## Installation Steps

This section is broken down into the following sections:

* ROS Kinetic (pending)
* OGRE (pending)
* Qt 5.x (pending)
* GLEW 1.11+ (pending)
* usb_cam (pending)
* SteamVR
* OpenVR and rviz_vive plugin
* NVIDIA Drivers

### SteamVR

1. Download Steam

2. Execute the following command:

	```
	mv ~/.steam/steam/* ~/.local/share/Steam/
	rmdir ~/.steam/steam
	ln -s ../.local/share/Steam ~/.steam/steam
	rm -rf ~/.steam/bin
	```

### OpenVR and rviz_vive plugin from [Andre Gilerson](https://github.com/AndreGilerson/rviz_vive)

1. Ensure that QT5 dependency for OpenVR is satisfied for later build step with gcc++
    
    ```
    export QT_SELECT=5
    ```
2. git clone OpenVR release v1.0.16
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
sudo apt install nvidia-396
```

Then reboot the PC for the changes to take effect.

## How to Run

1. Check that we are actually using the NVIDIA graphics card.
    * Check Ubuntu Settings > Details -- should see NVIDIA card listed in "Graphics"

    * Check NVIDIA card config through terminal using
        ```
        $ nvidia-settings
        ```

2. Start SteamVR through Steam and make sure to select SteamVR beta

3. Make sure Vive Base Stations are:
    * Connected to each other with the sync cable
    * One is on Channel A; the other on channel B)

4. Make sure the Vive headset recognizes both base stations
    * Aim the front of the headset at each of the base stations. This should cause the base stations to be recognized by the SteamVR server application.

5. Make sure that usb_cam dual launch file is looking at the correct /dev/videoX device

6. Edit demo.launch file to run steam server .sh file as launch-prefix param so we can roslaunch it

    Make sure that *demo.launch* in rviz_textured_sphere/src/launch/ contains the following code:
    ```
    <?xml version="1.0"?>
    <launch>
      <node pkg="rviz" type="rviz" name="rviz"
        args="-l -d $(find rviz_textured_sphere)/rviz_cfg/rviz_textured_sphere.rviz"
        output="screen"
        launch-prefix="${HOME}/.steam/steam/ubuntu12_32/steam-runtime/run.sh" />
    </launch>
    ```
        *Note: I had hardcored the launch-prefix path as /home/senior-design/.steam/....
         Check that ${HOME}/ actually works...*

7. Then, start ```roscore``` on one terminal.

8. Open a new terminal and source the *devel/setup.bash* of the catkin workspace

9. Start RVIZ with:

    ```
    roslaunch rviz_textured_sphere demo.launch
    ```

10. Add vive display plugin once in RVIZ. This should cause the stream to render in the HTC VIVE headset.


