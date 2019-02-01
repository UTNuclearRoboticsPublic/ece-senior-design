#!/usr/bin/env bash
#####################################################################
# Purpose:       Launch base station part of the system including 
#                rviz, textured sphere, network, and VR plugin
# Authors:       Kate Baumli, Daniel Diamont, Caleb Johnson
# Last modified: 01/20/2019 by Kate
#####################################################################

#####################################################################
# Parse args
#####################################################################
if [ $# -lt 1 ];
then
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-nc|--force-default-netconfig] [-b|--basehostname] [-bip|--baseip] [-r|--robohostname] [-rip|--roboip]"
    exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -c|--catkin)
    CATKIN=${2%/} # strip trailing slash 
    shift # past argument
    shift # past value
    ;;
    -l|--logfile)
    LOGFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -nc|--use-custom-netconfig)
    FORCE_DEFAULT_NETCONFIG="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--basehostname)
    BASENAME="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--robohostname)
    ROBONAME="$2"
    shift # past argument
    shift # past value
    ;;
    -bip|--baseip)
    BASEIP="$2"
    shift # past argument
    shift # past value
    ;;
    -rip|--roboip)
    ROBOIP="$2"
    shift # past argument
    shift # past value
    ;;

esac
done

if [ -z ${CATKIN} ];
then
    echo "ERROR: Must provide path to catkin workspace"
	echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-b basehostname] [-bip baseip] [-r robohostname] [-rip roboip]"
    exit 1
    # TODO: Make sure $CATKIN is a valid directory
fi

#####################################################################
# Configure log and vars
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="base_launch.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi

SPHERE_LAUNCH="vive.launch"
RVIZ_CONFIG_FILE="rviz_textured_sphere.rviz"
RVIZ_CONFIG="rviz_cfg"

#######################
# Network configuration
#######################
# Make backup copies of current /etc/hosts /etc/hostname /etc/network/interfaces for backup with which to restore later
#OLDEST="" # Mark oldest copies in this directory so they don't accidentally get overwritten if script is run dirty
#if [ -d utils/netconfig/backups/ ]; then
   # If the backups directory is empty, these are the oldest backups
 #  [ "$(ls -A utils/netconfig/backups/)" ] || OLDEST="-oldest"
#fi

# Check if user forced default network configuration
if [ "$FORCE_DEFAULT_NETCONFIG" == "true" ];
then
        # overwrite /etc/
        echo "[INFO]: User selected to use the default network configuration."
        echo "[INFO $MYFILENAME $LINENO]: User selected to use the default network configuration." >> "$LOGFILE"
        echo "[INFO]: Temporarily setting hostname as base until next restart."
        echo "[INFO $MYFILENAME $LINENO]: Temporarily setting hostname as base until next restart." >> "$LOGFILE"

        ( sudo hostname base )
        sudo cp utils/netconfig/basehostname /etc/hostname
        sudo cp utils/netconfig/hosts /etc/hosts
        sudo cp utils/netconfig/interfaces /etc/network/interfaces

        echo "[INFO]: Default Network configuration setup complete."
        echo "[INFO $MYFILENAME $LINENO]: Default Network configuration setup complete." >> "$LOGFILE"

# note: this predicate of the if statement is not working properly yet
# having issues dynamically setting the hostname (sudo doesn't like it)
elif [ "$FORCE_DEFAULT_NETCONFIG" == "false" -o "$FORCE_DEFAULT_NETCONFIG" == "" ];
then
        echo "[INFO]: User selected to use custom network configuration."
        echo "[INFO $MYFILENAME $LINENO]: User selected to use the custom network configuration." >> "$LOGFILE"
    
        # Check for dirty state
    diff utils/netconfig/hosts /etc/hosts > /dev/null
    EXITCODE_HOSTS=$?
    diff utils/netconfig/basehostname /etc/hostname > /dev/null
    EXITCODE_HOSTNAME=$?
    diff utils/netconfig/interfaces /etc/network/interfaces > /dev/null
    EXITCODE_INTERFACES=$?
    
    if [ "$EXITCODE_HOSTS" -ne 1 -o "$EXITCODE_HOSTNAME" -ne 1 -o "$EXITCODE_INTERFACES" -ne 1 ];
    then 
        # we are in a dirty state
        echo "[ERROR]: Netconfig in dirty state. Check log for more details."
        echo "[ERROR $MYFILENAME $LINENO]: Kill script was not executed the last time this script was run." >> "$LOGFILE"
        echo "[INFO $MYFILENAME $LINENO]: /etc/hosts , /etc/hostname , /etc/network/interfaces is in a dirty state." >> "$LOGFILE"
        echo "[INFO $MYFILENAME $LINENO]: Please specify if you wish to use our default network configuration by setting the -nc boolean flag." >> "$LOGFILE"
        echo "[INFO] $MYFILENAME $LINENO]: Otherwise, we recommend you look at the aforementioned files and configure them for your application." >> "$LOGFILE"
        echo "[INFO $MYFILENAME $LINENO] Remember to cleanly exit the environment by executing kill_launch.sh" >> "$LOGFILE"
        exit 1

    else # clean state
        
        echo "[INFO]: Network configuration in clean state."
        echo "[INFO $MYFILENAME $LINENO]: Network configuration in clean state." >> "$LOGFILE"
        # check that command line arguments are not null
        if [ -n "$ROBONAME" -a  -n "$ROBOIP"  -a  -n "$BASENAME"  -a -n "$BASEIP" ];
        then
            # all command line args were passed!

            # stash current files
            mkdir -p utils/netconfig/backups/
            sudo cp /etc/hostname utils/netconfig/backups/hostname
            sudo cp /etc/hosts utils/netconfig/backups/hosts
            sudo cp /etc/network/interfaces utils/netconfig/backups/interfaces
            echo "[INFO]: current network config stashed." 
            # copy defaults
            sudo hostname base
            sudo cp utils/netconfig/basehostname /etc/hostname
            sudo cp utils/netconfig/hosts /etc/hosts
            sudo cp utils/netconfig/interfaces /etc/network/interfaces

            # search and replace with sed
            # note: order matters! hostname change muts be done before hosts
            sudo sed -i "11s|.*|address ${BASEIP}|" "/etc/network/interfaces" 

            
            sudo sed -i "6s|.*|${BASENAME}|" "/etc/hostname"
            sudo hostname $BASENAME

            sudo sed -i "10s|.*|${BASEIP} ${BASENAME}|" "/etc/hosts"
            sudo sed -i "11s|.*|${ROBOIP} ${ROBONAME}|" "/etc/hosts"
            
            echo "[INFO $MYFILENAME $LINENO]: Network configuration updated." >> "$LOGFILE"

        else
            # incorrect command line args
            echo "[ERROR $MYFILENAME $LINENO]: Found null command line arguments." >> "$LOGFILE"
            echo "[ERROR]: Found null command line arguments."

	        echo "Usage: base_launch.sh <-c|--catkin path to catkin workspace> [-l|--logfile logfile] [-nc|--force-default-netconfig] [-b|--basehostname] [-bip|--baseip] [-r|--robohostname] [-rip|--roboip]"
            exit 1
        fi
    fi

else
    echo "[ERROR]: set -nc flag to 'true' or 'false'<default> (lowercase)."
fi

echo "END NETWORK CONFIG"
exit 1

#####################################################################
 # Source devel/setup.bash 
#####################################################################
# shellcheck disable=SC1090
source "$CATKIN"/devel/setup.bash

#####################################################################
 # Launch Rviz and textured sphere
#####################################################################
echo "[INFO: $MYFILENAME $LINENO] Attempting to launch rviz textured sphere with $SPHERE_LAUNCH" >> "$LOGFILE"
roslaunch --wait rviz_textured_sphere $SPHERE_LAUNCH && #configfile:="${RVIZ_CONFIG_FILE}"
echo "[INFO: $MYFILENAME $LINENO] rviz_textured_sphere launched with $SPHERE_LAUNCH" >> "$LOGFILE"
exit 0
