#! /bin/sh
exec 2> /dev/null

# read in the configuration file
source /etc/conf.d/ucarp

/sbin/ip addr add $UCARP_VIRTUAL_ADDRESS/$UCARP_VIRTUAL_NETMASK dev $UCARP_VIRTUAL_INTERFACE
