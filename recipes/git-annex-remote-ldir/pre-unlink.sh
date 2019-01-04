#!/usr/bin/env bash

set -eu -o pipefail -x

PACKAGE_HOME=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

${PACKAGE_HOME}/rmenv >& $PREFIX/.messages.txt

