#!/bin/bash
# Create a skeleton ruby project Directory and supporting files

PROJNAME="$1"

if [ -e $PROJNAME ]; then
	echo "Directory already exists, exiting...";
else
	echo "Creating project skeleton"
	mkdir $PROJNAME;
	mkdir $PROJNAME/lib;
	mkdir $PROJNAME/db;
	mkdir $PROJNAME/config;
	echo "Readme for: $PROJNAME" > $PROJNAME/README;
	echo "done"
fi
