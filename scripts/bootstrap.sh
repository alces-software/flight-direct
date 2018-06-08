#!/bin/bash
# Must be the root user
if (( UID != 0 )); then
  echo "$0: must run as root"
  exit 1
fi

# Sets the git_url from the server address
project_path='alces-software/flight-direct.git'
if [ -z "$FLIGHT_DIRECT_SERVER" ]; then
  git_address="https://github.com/$project_path"
else
  git_address="http://$FLIGHT_DIRECT_SERVER/$project_path"
fi

# Sets the install environment variables
install_path='/opt/flight-direct'

# Installs the git repo
yum -y -e0 install git
git clone "$git_address" "$install_path"

