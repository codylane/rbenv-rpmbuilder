#!/bin/bash

su - rpmbuild -c 'cd $HOME/rpmbuild/RPMS; python -m SimpleHTTPServer 8080'
