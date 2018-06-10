#
# Copyright 2018 YOUR NAME
#
# All Rights Reserved.
#

name "flight-direct"
maintainer "alces-software"
homepage "https://github.com/alces-software/flight-direct"

# Defaults to C:/flight-direct on Windows
# and /opt/flight-direct on all other platforms
install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "preparation"

# flight-direct dependencies/components
dependency('flight_direct')

# Version manifest file
dependency "version-manifest"

# Set the version numbering
# Setting versions is discussed in:
# http://nvwls.github.io/2016/11/05/building-an-omnibus-ruby.html
#
override 'ruby', version: '2.5.1'

exclude "**/.git"
exclude "**/bundler/git"
