#!/bin/sh
# DownloadSparkle
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Sparkle"
ERROR
cd "$(dirname "$0")/../${PRODUCT_NAME}"
REVISION=1024
svn co -r $REVISION http://svn01.23i.net/chatkit/trunk/Utilities/Sparkle
exit 0

http://sparkle.andymatuschak.org/files/Sparkle%201.5b1.zip
http://sparkle.andymatuschak.org/files/Sparkle%201.5b6.zip