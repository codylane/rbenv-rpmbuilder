#!/bin/bash

docker build -t rpmbuild-rbenv .
[ $? -eq 0 ] && ./run.sh
