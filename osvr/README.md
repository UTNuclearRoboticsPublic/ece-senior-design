# Installation

This directory contains a setup script that will setup and install OSVR software, the rviz plugins made by UT Nuclear Robotics Group, and the ROS package `usb_cam`. These files are all set up under your home directory inside a folder named `catkin-ws`.

Your final directory structure will look like this:

```bash
+-- catkin-ws/
    +-- build/
    +-- devel/
    +-- src/
```
# Getting the VR headset to display video:
1) Connect headset to laptop using USB
2) Start the OSVR server `source ~/.osvr_server_setup`
3) Open Rviz and run textured sphere:<br>
    Open a new terminal, then `source ~/catkin-ws/devel/setup.bash`</br><br>
    `roslaunch rviz_textured_sphere demo.launch`</br>
4) Connect headset through HDMI (in addition to USB that's already plugged in
5) Enter OSVR Headset plugin as option in the Rviz param configuration (on the left side of the screen)
Have fun with your new VR Headset
