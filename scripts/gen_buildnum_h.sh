#!/bin/bash

VERSTRING=$(git describe --tags --long)
OUT=$1

MAJOR=`echo $VERSTRING | cut -d'.' -f1`
MINOR=`echo $VERSTRING | cut -d'.' -f2`
REVIS=`echo $VERSTRING | cut -d'.' -f3 | cut -d'-' -f 1`
BUILD=`echo $VERSTRING | cut -d'-' -f2,3,4,5`
TINYBUILD=`echo $VERSTRING | cut -d'-' -f2`

rm -f $OUT

cat >> $OUT << __eof__
#ifndef __included_build_number_h
#define __included_build_number_h

#define VERSION_MAJOR $MAJOR
#define VERSION_MINOR $MINOR
#define VERSION_REVISION $REVIS
#define VERSION_BUILD "$BUILD"
#define VERSION_NUMBER "$MAJOR.$MINOR.$REVIS"
#define VERSION_STRING "$VERSTRING"

#define RESOURCE_VERSION $MAJOR,$MINOR,$REVIS,$TINYBUILD
#define RESOURCE_VERSION_STRING "$MAJOR, $MINOR, $REVIS, $TINYBUILD"

#endif

__eof__
