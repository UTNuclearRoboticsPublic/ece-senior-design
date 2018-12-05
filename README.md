# ECE Senior Design Project
# <Project Title Here>

---

[![Build Status](https://travis-ci.org/UTNuclearRoboticsPublic/ece-senior-design.svg?branch=master)](https://travis-ci.org/UTNuclearRoboticsPublic/ece-senior-design) [![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)

---

# Introduction

TODO
Provide end to end handling of data for live streaming video to the HTC Vive headset. This repository contains code used by the ECE Senior Design team composed of: Beathen Andersen, Kate Baumli, Daniel Diamont, Bryce Fuller, Caleb Johnson, John Sigmon. The team is advised by Dr. Mitchell Pyror, head of the University of Texas Nuclear Robotics Group.

* [Usage](#usage)
* [Extras](#extras)

# Contents

The repository contains two directories, `osvr` and `vive`. The `osvr` directory contains files from an earlier implementation of the project. The current working project is located in `vive`. Further details are contained in the `vive` directory.

TODO

```tree
	ece-senior-design
	├── install
	│    ├── config
	│    │    ├── dual-cam.launch
	│    │    ├── single-cam.launch
	│    │    ├── vive.launch
	│    │    └── vive_launch_config.rviz
	│    ├── ros_install.sh
	│    ├── textured_sphere_install.sh
	│    ├── usb_cam_install.sh
	│    └── vive_plugin_install.sh
	├── osvr
	│    ├── README.md
	│    └── osvr-setup.sh
	├── vive
	│    ├── README.md
	│    ├── modified_vive_display.cpp
	│    └── troubleshooting_install.md
	├── utils
	│    ├── find_dev_cam_name.sh
	│    └── kill_roscore.sh
	├── clean_install.sh
	├── kill_launch.sh
	├── single_node_launch.sh
	├── requirements
	└── README.md
```
