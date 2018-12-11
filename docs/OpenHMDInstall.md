# OpenHMD Installation
The manual process of installing OpenHMD That I got to work. There is also an apt install process I have yet to test for both HID API and OpenHMD. This will be worked on soon

OpenHMD api documentation found [here](http://openhmd.net/doxygen/0.1.0/openhmd_8h.html)

## Install Dependencies
* HIDAPI
* sdl2, libudev, libusb, libfox
* AutoTools for make
* GLEW
* Lots of other libraries, not sure how necessary all of them are when using apt install

## Apt Installs
sudo apt-get install libudev-dev libusb-1.0-0-dev libfox-1.6-dev

sudo apt-get install autotools-dev autoconf automake libtool

sudo apt-get install libsdl2-dev

sudo apt-get install build-essential libxmu-dev libxi-dev libgl-dev

sudo apt-get install libglew1.5-dev libglew-dev libglewmx1.5-dev libglewmx-dev freeglut3-dev

## Clone Repos
[HID API](https://github.com/OpenHMD/hidapi)
```bash
git clone git://github.com/signal11/hidapi.git
./bootstrap
./configure
make
sudo make install
```

[OpenHMD](https://github.com/OpenHMD/OpenHMDDemo)
```bash
git clone https://github.com/OpenHMD/OpenHMD.git
./autogen.sh
./configure --enable-openglexample
make
sudo make install
```
Their install instructions are really easy to follow as well.

## Clone Demo
The [demo](https://github.com/OpenHMD/OpenHMDDemo) is a self contained program that will render you inside a box. Looks pretty bad but it gets to usefulness and functionality across.
```bash
sudo apt-get install libogre-1.9-dev libois-dev libtinyxml-dev
git clone https://github.com/OpenHMD/OpenHMDDemo.git
cmake .
make
./OpenHMDDemo
```

## Note on fixing Vive resolution
 1. connect HTC Vive
 2. turn off vive display in ubuntu display GUI
 3. run program (it will render to screen)
 4. End program and turn display back on
 5. Run program and it started working

 Dont know how or why this worked but it did.
