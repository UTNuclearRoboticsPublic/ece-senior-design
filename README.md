# ECE Senior Design Project
# High Quality Video Transmission for Virtual Reality

---

[![Build Status](https://travis-ci.org/UTNuclearRoboticsPublic/ece-senior-design.svg?branch=master)](https://travis-ci.org/UTNuclearRoboticsPublic/ece-senior-design) [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

---

# Introduction

The goal of this project is to build a long distance virtual reality (VR) streaming system for the University of Texas at Austin [Nuclear Robotics Group](https://robotics.me.utexas.edu/) (UT NRG.)

This system will allow operators to control a robot which inspects radioactive nuclear facilities. Our system will take 360° video data, process and format the data so that it is compatible with the HTC Vive VR headset, and transmit the VR stream to the headset. One remote laptop will sit onboard the robot to process and transmit the VR feed.

This repository contains code used by the ECE Senior Design team composed of: Beathen Andersen, Kate Baumli, Daniel Diamont, Bryce Fuller, Caleb Johnson, John Sigmon. The team is advised by Dr. Mitchell Pyror, head of the University of Texas Nuclear Robotics Group.

* [Usage](#usage)
* [Extras](#extras)

# Contents

The repository contains two directories, `osvr` and `vive`. The `osvr` directory contains files from an earlier implementation of the project. The current working project is located in `vive`. Further details are contained in the `vive` directory.

```tree
	ece-senior-design/
	├── osvr/
	│    └── README.md
	├── vive/
	│    ├── README.md
    |    └── install/
	├── utils/
	├── docs/
	└── README.md
```
