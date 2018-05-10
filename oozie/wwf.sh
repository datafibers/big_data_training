#!/bin/bash
set -e
wfid=$1
watch "oozie job --info $wfid|tail -60"