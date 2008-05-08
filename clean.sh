#!/bin/bash
svn cleanup
echo
echo "The following files will be purged:"
echo
svn status --no-ignore | grep ^[I?] | sed 's/^[I?]//g' | sed 's/^[ ].//g'
echo
read -p "Continue (Y/N)?"
if [ "$REPLY" == "y" ]; then
	rm -rvf `svn status --no-ignore | grep ^[I?] | sed 's/^[I?]//g' | sed 's/^[ ].//g'`
else
	echo
	echo "No files removed."
	echo
fi
