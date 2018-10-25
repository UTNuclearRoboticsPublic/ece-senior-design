# Troubleshooting Effort Summary
	By Daniel Diamont

## How To Run

### To Run a Sample from OpenVR
```
~/.steam/steam/ubuntu12_32/steam-runtime/run.sh ../bin/linux64/hellovr_vulkan
```

### To Run RVIZ Textured Sphere with Vive VR Headset

1. Check that we are actually using the nvidia card (check ubuntu settings and check through terminal using
    ```
    $ nvidia-settings
    ```

2. Start SteamVR through Steam

3. Make sure base stations are connected with sync cable (Channel A and B)

4. Make sure the headset recognizes both base stations

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



## Installation Steps Taken:

1. Followed RVIZ Vive Plugin Installation procedure on [readme](https://github.com/AndreGilerson/rviz_vive)
	* Changed OpenVR path in CMakeLists.txt to point to openVR installation
		i.e. replace line 30 of rviz_vive/CMakeLists.txt to say
		```
		set(OPENVR "~${HOME}/openvr")
		```

	* Built OpenVR src code (at ~/openvr/src/) with:
		```
		$ cmake ..
		$ make
		```
	* Built catkin workspace with ''' catkin_make ''' command at root of catkin worspace. 
 
2. Applied fix for steamVR setup

	* Fix for steam [set-up problem](https://askubuntu.com/questions/470436/steam-cannot-set-up-steam-data)

	```
	mv ~/.steam/steam/* ~/.local/share/Steam/
	rmdir ~/.steam/steam
	ln -s ../.local/share/Steam ~/.steam/steam
	rm -rf ~/.steam/bin
	```


## Problem (SteamVR Error Ccode 102)

Running the RVIZ with Andre Gilerson's plugin (**rviz_vive**) causes a **segmentation
 fault**.

Running RVIZ with GDB and enabling a backtrace after the failure shows that the problem comes from the OpenVR installation during the initialization procedure. Specifically in a file called **openvr_api_public.cpp**, which is called by **vive_display.cpp**. More details can be found in the following log files:

	valgrind_dump.txt
	gdb_log.txt

It appears that **vive_display.cpp** attempts to load some DLL file with its _VR_Init()_ function. _VR_Init()_ returns error code 102 (**VRClientDLLNotFound**), and outputs a message saying to check a log file, which I was unable to find. Promptly after, a segmentation fault occurs when **vive_display.cpp** makes a call to **OGRE::TextureManager::createManual()**. It is unclear at the moment whether the SEG FAULT and the DLL problem are related.

This could be related to an issue pointed out in 2017 [here](https://github.com/ValveSoftware/openvr/issues/59), where it appears the openvr_api_public.cpp file attempts to unload a non-existent DLL file, which causes the SEG FAULT and crashes the application.

A related possible fix from an unmerged pull request can be found [here](https://github.com/ValveSoftware/openvr/pull/492).

Also, note that a post from July 13 shows that this is still an [open issue](https://github.com/ValveSoftware/openvr/issues/827).

## Problem Fix (SteamVR Error code 102)

#### Attempt 1 (failed) 

A team member (Beathan Andersen) and I took the following steps, with no change to the end result.

1. re-installed openVR
2. implemented the proposed fix in [pull request #492](https://github.com/ValveSoftware/openvr/pull/492).
3. Re-built the openVR source.
4. Re-built the rviz_vive plugin

#### Attempt 2 (success)

1. Reinstalled openVR
2. Ensured QT5 dependecy was satisfied
3. Re-built openVR source using gcc++-4.9 toolchain
4. Ran hellovr_opengl sample from openVR

Passed DLL error, later got HMD error 306 (shared IPC Compositor Connect Failed)

QT5 fix:
```
export QT_SELECT=5
```

GCC ToolChain Fix:
```
sudo apt-get install g++-4.9 
git clone https://github.com/ValveSoftware/openvr.git
#Apply the patch https://gist.github.com/toastedcrumpets/d4dde447d9d23fcea4181bbbfadd3487
cd openvr/samples/
mkdir build
cd build
CXX=g++-4.9 cmake ../
make
#Now run the examples using the steam runtime environment
~/.steam/steam/ubuntu12_32/steam-runtime/run.sh ../bin/linux64/hellovr_vulkan
```

## Problem Fix (SteamVR Error code 306)

NVIDIA drivers were out of date, so SteamVR was using the integrated Intel GPU instead of our NVIDIA GeForce GTX 980M card.

Drivers were updated as follows:

```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-396
```

Then the PC was rebooted for the changes to take effect.


## System Information

* OpenVR release [v1.0.16](https://github.com/ValveSoftware/openvr/releases/tag/v1.0.16)
* SteamVR 1533664367

