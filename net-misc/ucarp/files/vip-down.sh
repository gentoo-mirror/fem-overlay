#!/bin/bash
# Copyright 2005 Mike Glenn & Homechicken Software
# Distributed under the terms of the GNU General Public License v2
 
# read in the configuration file
source /etc/conf.d/ucarp
 
# bring down the virtual interface
$IFCONFIG $INTERFACE down

