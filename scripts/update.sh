#!/bin/bash

echo Updating primary repository...
git pull origin master

echo Updating submodules...
MODULES="contrib contrib/crisscross"
ORIGINAL=`pwd`

for a in $MODULES; do
	cd $a
	echo -n "$a: "
	git pull origin master
	cd $ORIGINAL
done
