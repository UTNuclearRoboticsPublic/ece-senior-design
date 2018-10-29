#!/usr/bin/env
# Authors:	Kate Baumli & John Sigmon
# Date:		October 28, 2018
# Purpose:	This script launches all processes necessary to connect panospheric cameras to vive headset
#		via ros, rviz plugin, and steam vr


# 0 Load args

# 1 Launch roscore (in its own terminal or background it)
x-terminal-emulator -e roscore
echo hello
# 2 Source ros enviornment script
source $CATKIN/devel/setup.bash
echo world
# 3 Configure cameras (find device numbers and edit launch files)

# 4 Launch usb cam in (its own terminal or background it)

# 5 Launch Steam VR (?)

# 6 Launch textured sphere / Rviz

# 7 Point Rviz to vive plugin (?) 
