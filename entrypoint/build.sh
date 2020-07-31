#!/bin/bash
rm /bin/koffer 2>/dev/null
rm -rf /root/koffer 2>/dev/null
goCmd=$(which go)
${goCmd} get github.com/go-git/go-git
set -x
${goCmd} build koffer.go
mv -f koffer /bin/koffer
