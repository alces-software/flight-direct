#!/bin/bash
# Ensures a version is given
set -e
version="$1"
: ${version?'No version number given'}
file="flight-direct-$version.tar.gz"

# Fetches the tarball
url="https://s3-eu-west-1.amazonaws.com/flight-direct/releases/el7/$file"
curl $url > $file

# Extracts the tarball
tar -zxf $file

