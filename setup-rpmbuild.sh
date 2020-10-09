#!/bin/bash

rpmdev-setuptree

git clone https://github.com/rbenv/rbenv.git ${HOME}/rbenv

mkdir -p ${HOME}/rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ${HOME}/rbenv/plugins/ruby-build

RBENV_VER=$($HOME/rbenv/bin/rbenv --version | cut -d" " -f2 | cut -d "-" -f1)
echo "RBENV_VER=${RBENV_VER}"

mv $HOME/rbenv/ $HOME/rbenv-$RBENV_VER

tar czf $HOME/rbenv-$RBENV_VER.tar.gz -C $HOME rbenv-$RBENV_VER
cp $HOME/rbenv-$RBENV_VER.tar.gz $HOME/rpmbuild/SOURCES/rbenv-$RBENV_VER.tar.gz

# update the TEMPLATE for the rbenv.spec

[ -f "/rbenv.spec" ] && cp /rbenv.spec $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec
sed -i.orig -e "s/%%<RBENV_VERSION>%%/$RBENV_VER/" $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec

rpmbuild -ba $HOME/rpmbuild/SPECS/rbenv-${RBENV_VER}.spec
