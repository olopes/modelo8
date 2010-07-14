#!/bin/sh
mkdir -p modelo8-1.0-beta-src/src
mkdir -p modelo8-1.0-beta-win32-bin
cp gpl.txt RELEASE_NOTES README modelo8-1.0-beta-src
cp src/* modelo8-1.0-beta-src/src
cp gpl.txt RELEASE_NOTES README modelo8-1.0-beta-win32-bin
make -C src
cp src/modelo8.exe modelo8-1.0-beta-win32-bin
zip -r modelo8-1.0-beta-src.zip modelo8-1.0-beta-src
zip -r modelo8-1.0-beta-win32-bin.zip modelo8-1.0-beta-win32-bin

