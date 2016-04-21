#!/bin/bash

rpmdev-setuptree

git clone https://github.com/rbenv/rbenv.git rbenv
git clone https://github.com/rbenv/ruby-build.git rbenv/plugins/ruby-build

rsync -av --exclude .git $HOME/rbenv/ $HOME/rbenv-latest

RBENV_VER=$($HOME/rbenv-latest/bin/rbenv --version | cut -d" " -f2 | cut -d "-" -f1)

mv $HOME/rbenv-latest/ $HOME/rbenv-$RBENV_VER

tar czf $HOME/rbenv-$RBENV_VER.tar.gz -C $HOME rbenv-$RBENV_VER
cp $HOME/rbenv-$RBENV_VER.tar.gz $HOME/rpmbuild/SOURCES/rbenv-$RBENV_VER.tar.gz

# update the TEMPLATE for the rbenv.spec

[ -f "/rbenv.spec" ] && cp /rbenv.spec $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec
sed -i.orig -e "s/%%<RBENV_VERSION>%%/$RBENV_VER/" $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec

rpmbuild -ba $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec
