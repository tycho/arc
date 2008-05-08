#!/bin/bash

echo Configuring Steven\'s git globals...
if [ $(uname -o) == "Cygwin" ]; then
	echo Disabling file mode checking...
	git repo-config core.filemode false
fi
git-config --global core.compression 9
git-config --global color.diff auto
git-config --global color.status auto
git-config --global color.branch auto
