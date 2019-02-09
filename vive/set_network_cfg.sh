#!/usr/bin/env bash
#####################################################################
# Purpose:       Launch base station part of the system including 
#                rviz, textured sphere, network, and VR plugin
# Authors:       Kate Baumli, Daniel Diamont, Caleb Johnson
# Last modified: 01/20/2019 by Kate
#####################################################################

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


#####################################################################
# Parse args
#####################################################################
if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
	echo "Usage: sudo bash set_network_cfg.sh <-isbase (y/n)|--y for base, n for robo> [-l|--logfile logfile] [-b|--basehostname] [-bip|--baseip] [-r|--robohostname] [-rip|--roboip]"
    exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -isbase|--isbase)
    ISBASE="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--logfile)
    LOGFILE="$2"
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


if [ -z "${ISBASE}" ];
then
    echo 'Must specify if this machine is base or robo.'
    echo 'Use -isbase (y or n)'
    exit 1;
fi

if [ -z "${BASENAME}" ];
then
    BASENAME="base"
fi

if [ -z "${ROBONAME}" ];
then
    ROBONAME="robo"
fi

if [ -z "${BASEIP}" ];
then
    BASEIP="10.0.0.1"
else
    if ! valid_ip "$BASEIP";
        then echo 'Invalid base station IP'; 
        exit 1;
    fi
fi

if [ -z "${ROBOIP}" ];
then
    ROBOIP="10.0.0.2"
else
    if ! valid_ip "$ROBOIP";
        then echo 'Invalid robot station IP'; 
        exit 1;
    fi
fi


#####################################################################
# Configure log and vars
#####################################################################
timestamp() {
    date +"%T"
}
MYFILENAME="set_network_cfg.sh"
if [[ -z "$LOGFILE" ]];
then
    LOGFILE="log$(timestamp)$MYFILENAME.txt"
fi


####################################################################
# Set ROS environment variables and set up network files
####################################################################
echo "export ROS_MASTER_URI=http://$ROBOIP:11311">>~/.bashrc

# shellcheck disable=SC2188
# shellcheck disable=SC2129

if [ "$ISBASE" == "y" ];
then
    echo "export ROS_IP=$BASEIP">>~/.bashrc
elif [ "$ISBASE" == "n" ];
then
    echo "export ROS_IP=$ROBOIP">>~/.bashrc
else
    echo 'Improper use of -isbase. Use -isbase (y or n)'
fi

> /etc/hosts
echo '127.0.0.1       localhost'>>/etc/hosts
echo "$BASEIP        $BASENAME">>/etc/hosts
echo "$ROBOIP        $ROBONAME">>/etc/hosts

> /etc/hostname
if [ "$ISBASE" == "y" ];
then
    echo "$BASENAME">>/etc/hostname
elif [ $ISBASE == "n" ];
then
    echo "$ROBONAME">>/etc/hostname
else
    echo 'Improper use of -isbase. Use -isbase (y or n)'
fi

#####################################################################
# Force restart to finalize network settings
#####################################################################
shutdown now -r
