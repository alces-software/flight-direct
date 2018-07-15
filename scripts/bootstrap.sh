#!/bin/bash
# Ensures a version is given
set -e
version="$1"
: ${version:?'No version number given'}
tarball="flight-direct-$version.tar.gz"

# Changes to the install directory
FL_INSTALL_DIR=${FL_INSTALL_DIR:-'/opt'}
pushd $FL_INSTALL_DIR >/dev/null

# Fetches the tarball
url="https://s3-eu-west-1.amazonaws.com/flight-direct/releases/el7/$tarball"
curl -f $url > $tarball

# Extracts the tarball
tar -zxf $tarball

# Sets up the profile
sys_profile='/etc/profile.d/flight-direct.sh'
fd_profile="$FL_INSTALL_DIR/flight-direct/etc/profile.sh"
echo "source $fd_profile" > $sys_profile

# Install Complete
cat <<EOF

FlightDirect has been successfully installed
Restart your current shell before continuing

EOF

# Moves back to the original dir
popd >/dev/null
