#!/bin/bash -x
goCmd=(which go)
goCmd="/usr/local/go/bin/go"
${goCmd} build koffer.go
cp -f koffer /bin/koffer
