#!/bin/bash

# Run this to start Misterhouse

MH="/home/rpwoodbu/code/misterhouse"
OPTS="-tk 0"

mkdir -p /tmp/mh_data
ls "${MH}"/persistent_data/* | grep -v 'README' | xargs -I FILES cp FILES "${MH}"/data/
export mh_parms="${MH}/mh.private.ini"
cd "${MH}/mh/bin"
exec perl mh $OPTS
