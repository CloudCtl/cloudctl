#!/bin/bash -x
goCmd=$(which go)
#goCmd="/usr/local/go/bin/go"
${goCmd} get github.com/go-git/go-git
${goCmd} build koffer.go
cp -f koffer /bin/koffer
