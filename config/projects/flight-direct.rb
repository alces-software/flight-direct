#
# Copyright 2018 YOUR NAME
#
# All Rights Reserved.
#

require 'pry'

name "flight-direct"
maintainer "alces-software"
homepage "https://github.com/alces-software/flight-direct"

# Defaults to C:/flight-direct on Windows
# and /opt/flight-direct on all other platforms
install_dir (ENV["FL_ROOT"] || "#{default_root}/#{name}")

build_version Omnibus::BuildVersion.semver

# Creates required build directories
dependency "preparation"

# flight-direct dependencies/components
dependency 'flight-direct'

# Version manifest file
dependency "version-manifest"

# Set the version numbering
# Setting versions is discussed in:
# http://nvwls.github.io/2016/11/05/building-an-omnibus-ruby.html
#
override 'ruby', version: '2.5.1'

# Work around the bud in Bundler `1.16.2` which struggles with `git` paths
# https://github.com/bundler/bundler/issues/6563
# It has been recommended to down grade to version `1.16.0`
# RubyGem also packages in bundler in latter versions, so it also needs to be
# downgraded for the meantime
override 'rubygems', version: '2.7.0'
override 'bundler', version: '1.16.0'

exclude "**/.git"
exclude "**/bundler/git"

