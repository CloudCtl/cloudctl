#!/bin/bash -x
rm /bin/koffer
goCmd=$(which go)
${goCmd} get github.com/go-git/go-git
${goCmd} build koffer.go
cp -f koffer /bin/koffer
