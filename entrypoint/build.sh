#!/bin/bash -x
goCmd=$(which go)

rm /bin/koffer 2>/dev/null
rm -rf /root/koffer 2>/dev/null
mkdir -p /tmp/bin

set -x
${goCmd} get github.com/go-git/go-git
${goCmd} build koffer.go

cp -f koffer /bin/koffer 2>/dev/null
mv -f koffer /tmp/bin/koffer
