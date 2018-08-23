#!/bin/bash

# Exit if anything exists with a non-zero status
set -e

build_dir=/opt
build_root="$build_dir/flight-direct"

# Errors if flight is already present
if [[ -e $build_root || "$FL_ROOT" ]]; then
  cat <<-ERROR >&2
Build Failed: An existing installation of FlightDirect has been dectected
Please rerun the production build on a blank VM
ERROR
  exit 1
fi

# Pulls the version number from the tarball
version=${1?'No build version given'}
tarball_name="flight-direct-$version.tar.gz"

# Installs the required yum packages
# NOTE: rpm-build is only installed so the omnibus build doesn't fail, and
# exits normally. The `rpm` is otherwise ignored
yum install epel-release -y
yum update -y
yum install git rpm-build python-pip cmake -y
pip install --upgrade pip
pip install awscli

# Checks out the build version from git
cd ~
git clone https://github.com/alces-software/flight-direct.git
cd flight-direct
git fetch
git checkout $version

# Installs rvm, bundler, and development gems
. dev_bin/dev_bin_setup
bundle_install_rvm
. ~/.bashrc

# Builds the project
export FL_ROOT=$build_root
export LD_LIBRARY_PATH=$FL_ROOT/embedded/lib:$LD_LIBRARY_PATH
omnibus build flight-direct

# Creates the tarball
cd $build_dir
tar -zcvf $tarball_name flight-direct

# Publishes the tarball to S3
export PATH=~/.local/bin:$PATH
aws s3 cp $tarball_name s3://flight-direct/releases/el7/$tarball_name \
  --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
