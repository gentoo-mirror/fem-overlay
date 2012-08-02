#!/bin/bash                                                                              
#                                                                                        
# USAGE:                                                                                 
# ./check_hddtemp.sh <device> <warn> <crit>                                              
# Nagios script to get the temperatue of HDD from hddtemp                                
#                                                                                        
# You may have to let nagios run this script as root                                     
# This is how the sudoers file looks in my debian system:                                
# nagios  ALL=(root) NOPASSWD:/usr/lib/nagios/plugins/check_hddtemp.sh                   
#
# Version 1.2
#
# CHANGELOG:
# 1.0	- initial release / source unknown :(
# 1.1	- check script running as root or set-user-id-Bit is set
# 1.1.1 - fix error messages

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3 

function usage()
{               
        echo "Usage: ./check_hddtemp.sh <device> <warn> <crit>"
}                                                              

function check_root()
{                    
        # check suidbit for hddtemp
        if [ ! -u ${HDDTEMP} ] && [[ "x$(${WHOAMI})" != "xroot" ]]; then
                echo "HDDTEMP WARNING - script not running as root, so setuid-bit should set for ${HDDTEMP}, please run \"chmod +s ${HDDTEMP}\""
                exit ${WARNING}
        fi
}                                                                         
function check_arg()                                                      
{                                                                         
        # make sure you supplied all 3 arguments                          
        if [ $# -ne 3 ]; then                                             
                usage                                                     
                exit $OK                                                  
        fi                                                                
}                                                                         
function check_device()                                                   
{                                                                         
        # make sure device is a special block                             
        if [ ! -b $DEVICE ];then                                          
                echo "UNKNOWN: $DEVICE is not a block special file"       
                exit $UNKNOWN                                             
        fi                                                                
}                                                                         
function check_warn_vs_crit()                                             
{                                                                         
        # make sure CRIT is larger than WARN                              
        if [ $WARN -ge $CRIT ];then                                       
                echo "UNKNOWN: WARN value may not be greater than or equal the CRIT value"
                exit $UNKNOWN                                                             
        fi                                                                                
}                                                                                         

function init()
{              
check_root   
check_arg $*   
check_device   
check_warn_vs_crit
}                 

function get_hddtemp()
{                     
        # gets temperature and stores it in $HEAT
        # and make sure we get a numeric output  
        if [ -x $HDDTEMP ];then                  
                HEAT=`$HDDTEMP $DEVICE -n`       
                case "$HEAT" in                  
                [0-9]* )                         
                        echo "do nothing" > /dev/null
                        ;;
                * )
                        echo "UNKNOWN: Could not get temperature from: $DEVICE"
                        exit $UNKNOWN
                        ;;
                esac
        else
                echo "UNKNOWN: cannot execute $HDDTEMP"
                exit $UNKNOWN
        fi
}
function check_heat()
{
        # checks temperature and replies according to $CRIT and $WARN
        if [ $HEAT -lt $WARN ];then
                echo "OK: Temperature is below warn treshold ($DEVICE is $HEAT) | temp=$HEAT;$WARN;$CRIT;0;60"
                exit $OK
        elif [ $HEAT -lt $CRIT ];then
                echo "WARNING: Temperature is above warn treshold ($DEVICE is $HEAT) | temp=$HEAT;$WARN;$CRIT;0;60"
                exit $WARNING
        elif [ $HEAT -ge $CRIT ];then
                echo "CRITICAL: Temperature is above crit treshold ($DEVICE is $HEAT) | temp=$HEAT;$WARN;$CRIT;0;60"
                exit $CRITICAL
        else
                echo "UNKNOWN: This error message should never occur, if it does happen anyway, get a new cup of coffee and fix the code :)"
                exit $UNKNOWN
        fi

}

# -- Main -- #

HDDTEMP=/usr/sbin/hddtemp
WHOAMI=$(which whoami)

DEVICE=$1
WARN=$2
CRIT=$3


init $*
get_hddtemp
check_heat
