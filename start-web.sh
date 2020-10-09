#!/bin/bash

su - rpmbuild -c 'cd $HOME/rpmbuild/RPMS; python2 -m SimpleHTTPServer 8080'
