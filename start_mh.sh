#!/bin/bash

# Run this to start Misterhouse

MH="/home/rpwoodbu/code/misterhouse"
OPTS="-tk 0"

mkdir -p /tmp/mh_data
export mh_parms="${MH}/mh.private.ini"
cd "${MH}/mh/bin"
tmux new-session -s misterhouse "./mhl $OPTS"
