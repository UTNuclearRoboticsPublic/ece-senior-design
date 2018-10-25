#!/usr/bin/env bash

# Author John Sigmon
# Last modified 9/20/18

sudo apt update && sudo apt upgrade
sudo apt install libsdl2-dev libboost1.58-dev libboost-thread1.58-dev 
sudo apt install libboost-program-options1.58-dev libboost-filesystem-dev 
sudo apt install libusb-1.0-0-dev ros-kinetic-libuvc-ros

CATKIN=~/catkin-ws
BUILD="build"
SRC="src"

mkdir -p "$CATKIN" && cd "$CATKIN"
mkdir "$BUILD"
mkdir "$SRC"

# Clone and build libfunctionality and libuvs
cd $BUILD
git clone --recursive https://github.com/OSVR/libfunctionality.git
git clone https://github.com/ktossell/libuvc.git

# Build libfunctionality
cd libfunctionality
cmake . -DCMAKE_INSTALL_PREFIX=~/osvr
make
make install

# Build libuvc
cd $CATKIN/$BUILD
cd libuvc
mkdir build
cd build
cmake ..
make && sudo make install

# Clone and build OSVR Core
cd $CATKIN/$BUILD
git clone --recursive https://github.com/OSVR/OSVR-Core.git

cd OSVR-Core

# Edit the CMakeLists.txt file
sed -i -e $'s/find_package(OpenCV)/set(OpenCV_DIR "\/opt\/ros\/kinetic\/share\/OpenCV-3.3.1\/")\\\n    find_package(OpenCV COMPONENTS core videoio imgproc features2d calib3d highgui flann ml imgcodecs)/g' CMakeLists.txt

sed -i $'/opencv_features2d/a\\\n            opencv_ml\\\n            opencv_imgcodecs' CMakeLists.txt

sed -i $'/list(REMOVE_DUPLICATES OPENCV_MODULES_USED)/a\\\n    # Set configuration mapping from RelWithDebInfo to NONE for each imported opencv module\\\n    foreach(_cvMod ${OPENCV_MODULES_USED})\\\n        message(STATUS "Adding mapping to component: ${_cvMod}")\\\n        set_property(TARGET ${_cvMod} APPEND PROPERTY MAP_IMPORTED_CONFIG_RELWITHDEBINFO NONE)\\\n    endforeach()\\\n    include_directories("${OpenCV_INCLUDE_DIRS}")' CMakeLists.txt

# Build OSVR
cd $CATKIN/$BUILD/OSVR-Core
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=~/osvr
make -j4
make install

# Configure group permissions
CURRENTGROUP=$(id -g -n)
sudo sed -i "s/plugdev/$CURRENTGROUP/g" /etc/udev/rules.d/50-OSVR.rules
sudo udevadm control --reload-rules && sudo udevadm trigger

# Setup rviz_plugin_osvr
cd $CATKIN/$SRC
git clone https://github.com/Veix123/rviz-plugin-osvr.git
cd $CATKIN/$BUILD/rviz-plugin-osvr/
cmake ..
cd $CATKIN/$SRC/rviz-plugin-osvr/
cmake ..
cd $CATKIN/
catkin_make

# Setup rviz_texture_osvr
cd $CATKIN/$SRC
git clone https://github.com/UTNuclearRoboticsPublic/rviz_textured_sphere.git
cd $CATKIN/$BUILD/rviz_textured_sphere/
cmake ..
cd $CATKIN/$SRC/rviz_textured_sphere/
cmake ..
cd $CATKIN/
catkin_make

echo "export OSVR_CORE=~/osvr" >> ~/.bashrc

# Setup usb_cam
cd $CATKIN/$SRC
git clone https://github.com/ros-drivers/usb_cam.git
cd $CATKIN/
catkin_make

echo "Setup Finished!"
