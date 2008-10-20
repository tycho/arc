#!/bin/bash

git submodule init contrib/crisscross
git submodule update contrib/crisscross
cd contrib/crisscross
git checkout master
