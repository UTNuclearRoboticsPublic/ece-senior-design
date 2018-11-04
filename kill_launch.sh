#/usr/bin/env bash
# Authors:	Kate Baumli & John Sigmon & Beathan
# Date:		November 4, 2018
# Purpose:	This script kills all launches used in single_node_launch.sh
#		 	via ros, rviz plugin, and steam vr

STEAM=$(ps -uf | awk '/steam/ {print $2}')
kill $STEAM 2> /dev/null

ROSCORE=$(ps -uf | awk '/roscore/ {print $2}')
kill $ROSCORE 2> /dev/null

