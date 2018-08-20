#!/bin/bash
set -e

# The comment below is REQUIRED for bootstrapping an offline install
# anvil_url=

# Sets the tarball name and url depending on the type of install
if [ "$anvil_url" ]; then
  tarball='flight-direct.tar.gz'
  url="$anvil_url/flight-direct/$tarball"
else
  # Ensures a version is given
  version="$1"
  : ${version:?'No version number given'}

  tarball="flight-direct-$version.tar.gz"
  url="https://s3-eu-west-1.amazonaws.com/flight-direct/releases/el7/$tarball"
fi

# Changes to the install directory
FL_INSTALL_DIR=${FL_INSTALL_DIR:-'/opt'}
pushd $FL_INSTALL_DIR >/dev/null

# Downloads the tarball
curl -f $url > $tarball

# Extracts the tarball
tar -zxf $tarball

# Runs the installer
bash "$FL_INSTALL_DIR"/flight-direct/scripts/install.sh

# Moves back to the original dir
popd >/dev/null
