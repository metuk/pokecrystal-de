#!/bin/sh
# One round of the porting pipeline: build, locate, replace text/strings, build, locate.
set -e
RGBDS=${RGBDS:-../rgbds-1.0.4/}
make -j"$(nproc)" RGBDS="$RGBDS" 2>&1 | grep -iE "error" && exit 1
python3 tools/de/locate.py | sed -n 2p
python3 tools/de/retext.py | grep -E "^replaced"
python3 tools/de/restring.py | head -1
make -j"$(nproc)" RGBDS="$RGBDS" 2>&1 | grep -iE "error" && exit 1
python3 tools/de/locate.py | sed -n 2p
tools/romdiff.py | grep "bytes match"
python3 tools/de/todo.py | head -1
