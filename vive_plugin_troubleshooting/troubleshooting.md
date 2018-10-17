# Troubleshooting Effort Summary
	By Daniel Diamont

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


## Problem

Running the RVIZ with Andre Gilerson's plugin (**rviz_vive**) causes a **segmentation
 fault**.

Running RVIZ with GDB and enabling a backtrace after the failure shows that the problem comes from the OpenVR installation during the initialization procedure. Specifically in a file called **openvr_api_public.cpp**, which is called by **vive_display.cpp**. More details can be found in the following log files:

	valgrind_dump.txt
	gdb_log.txt

It appears that **vive_display.cpp** attempts to load some DLL file with its _VR_Init()_ function. _VR_Init()_ returns error code 102 (**VRClientDLLNotFound**), and outputs a message saying to check a log file, which I was unable to find. Promptly after, a segmentation fault occurs when **vive_display.cpp** makes a call to **OGRE::TextureManager::createManual()**. It is unclear at the moment whether the SEG FAULT and the DLL problem are related.

This could be related to an issue pointed out in 2017 [here](https://github.com/ValveSoftware/openvr/issues/59), where it appears the openvr_api_public.cpp file attempts to unload a non-existent DLL file, which causes the SEG FAULT and crashes the application.

A related possible fix from an unmerged pull request can be found [here](https://github.com/ValveSoftware/openvr/pull/492).

Also, note that a post from July 13 shows that this is still an [open issue](https://github.com/ValveSoftware/openvr/issues/827).

## Attempt To Solve Problem

A team member (Beathan Andersen) and I took the following steps, with no change to the end result.

1. re-installed openVR
2. implemented the proposed fix in [pull request #492](https://github.com/ValveSoftware/openvr/pull/492).
3. Re-built the openVR source.
4. Re-built the rviz_vive plugin

## System Information

* OpenVR release [v1.0.17](https://github.com/ValveSoftware/openvr/releases/tag/v1.0.17)

