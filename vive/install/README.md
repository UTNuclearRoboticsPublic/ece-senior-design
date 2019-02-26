# Installation of Video Display Module

## Basic Clean Installation
To install the full module for the first time, start by creating or locating the catkin workspace you plan to use. Then run the following:

```bash
cd install
bash install.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile]
```

You must build the catkin workspace after intallation.

```bash
cd <catkin workspace>
catkin build
```

Note that `catkin_make` can also be used to build your workspace, however the two methods cannot be combined. See [https://catkin-tools.readthedocs.io/en/latest/migration.html](https://catkin-tools.readthedocs.io/en/latest/migration.html) for more details.

To ensure that the installation process was correct, check the log file that is created in the directory you called install.sh from. 

## Individual Installations
Each subsystem has its own installation script. If you only need one, navigate to [`install/utils`](utils) for the desired script.
