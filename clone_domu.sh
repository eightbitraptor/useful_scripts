#!/bin/bash
# clone_domu: A script to automatically clone a redhat domu.
# Usage: clone_domu.sh <originalname> <newname>

usage()
{
cat << EOF
usage: $0 ORIGINAL_NAME NEW_NAME [OPTIONS]

OPTIONS:
	-v		verbose output
	-h		show this help message
	-d		set the volgroup name
	-c		the xen config file path
	
$0 will clone a Xen domU, changing the name in the process. Several assumptions are made in the process
	1) Your Dom0's and DomU's are all running RHEL5
	2) Your Volgroups are located in /dev
	3) Your DomU configs are at /etc/xen (can be overridden)
	
EOF
}

CONFIG_DIR="/etc/xen"
VOLGRP="xen"
VERBOSE=0

while getopts "hd:c:" OPTION
do
	case $OPTION in
		h)	usage
			exit 1
			;;
		d)	VOLGRP="$OPTARG"
			;;
		c) 	CONFIG_DIR=$OPTARG
			;;
		?) 	usage
			exit
			;;
		*)	
	esac
done
shift $(($OPTIND - 1))

ORIG_NAME=$1
NEW_NAME=$2

if [[ -z $ORIG_NAME ]] || [[ -z $NEW_NAME ]]
then
	usage
	exit 1
fi

lvcreate -s -L 1G -n "$ORIG_NAME"-snapshot-disk /dev/"$VOLGRP"/"$ORIG_NAME"-disk 

sed -e s/"$ORIG_NAME"/"$ORIG_NAME"-snapshot/g "$CONFIG_DIR"/"$ORIG_NAME" > "$CONFIG_DIR"/"$ORIG_NAME"-snapshot

# Grab the disk size of the original lvm volume from lvdisplay
SIZE=`lvdisplay -v /dev/$VOLGRP/$ORIG_NAME-disk | grep -e '[0-9]\{2\}\.' | sed 's/LV Size\s*\([0-9]\{2\}\)\.[0-9]\{2\}\s\([GMK]\)[Bb]/\1\2/'`
# Create the new machine
lvcreate -n "$NEW_NAME"-disk xen -L$SIZE
virt-clone -o $ORIG_NAME-snapshot -n $NEW_NAME -f /dev/"$VOLGRP"/$NEW_NAME-disk

# remove the temporary snapshot lvm
lvremove -f /dev/$VOLGRP/$ORIG_NAME-snapshot-disk
rm -f $CONFIG_DIR/$ORIG_NAME-snapshot

cat << EOF
The VM has been cloned, I am now going to start the VM and connect you to the console, where you must
Login and change the hostname of the machine. For Redhat DomU's this can be acheived by editing:
	/etc/sysconfig/network
	/etc/sysconfig/network-scripts/ifcfg-eth0
And then doing a service network restart as root
Have Fun!
(press any key to continue)
EOF

read confirm

xm create $NEW_NAME
xm console $NEW_NAME
