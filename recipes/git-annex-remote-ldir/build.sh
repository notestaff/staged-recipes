#!/bin/bash

set -eu -o pipefail -x

BINARY_HOME=$PREFIX/bin
PACKAGE_HOME=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

mkdir -p $BINARY_HOME
mkdir -p $PACKAGE_HOME/envs

binary_script="${PACKAGE_HOME}/git-annex-remote-ldir"
shim="${BINARY_HOME}/git-annex-remote-ldir"

cp $RECIPE_DIR/git-annex-remote-ldir $binary_script
chmod u+x $binary_script

# tail -n +3 git-annex-remote-ldir > $binary_script
# chmod u+x $binary_script

PKG_ENV_PATH=${PACKAGE_HOME}/envs/PRIV-git-annex-remotes-aux-env-01

cp $RECIPE_DIR/shim $shim
#echo "source activate $PKG_ENV_PATH" >> $shim
echo "if [ ! -d \"$PKG_ENV_PATH\" ]; then" >> $shim
echo "   conda create -p $PKG_ENV_PATH -c broad-viral -c conda-forge -y annexremote > /dev/null" >> $shim
echo "fi" >> $shim
echo "source activate $PKG_ENV_PATH" >> $shim
echo "$binary_script" >> $shim
chmod u+x $shim

mkenv=${PACKAGE_HOME}/mkenv
echo '#!/usr/bin/env bash' > $mkenv
echo '' >> $mkenv
echo 'set -eux -o pipefail' >> $mkenv
echo '' >> $mkenv
echo "conda create -p $PKG_ENV_PATH -c broad-viral -c conda-forge -y annexremote ncurses python=3" >> $mkenv

chmod u+x $mkenv


rmenv=${PACKAGE_HOME}/rmenv
echo '#!/usr/bin/env bash' > $rmenv
echo '' >> $rmenv
echo 'set -eux -o pipefail' >> $rmenv
echo '' >> $rmenv
echo "conda env remove -p $PKG_ENV_PATH -y" >> $rmenv

chmod u+x $rmenv
