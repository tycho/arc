#!/bin/bash

git submodule init contrib
git submodule update contrib
cd contrib
git branch -D master
git checkout -t -b master origin/master

./prep-repo.sh
