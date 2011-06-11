#!/bin/bash

# Run this to start Misterhouse

MH="/home/rpwoodbu/code/misterhouse"
OPTS="-tk 0"

export mh_parms="${MH}/mh.private.ini"
cd "${MH}/mh/bin"
./mhl $OPTS
