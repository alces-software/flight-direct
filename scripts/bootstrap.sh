#!/bin/bash
# Must be the root user
if (( UID != 0 )); then
  echo "$0: must run as root"
  exit 1
fi

# Sets the install path variables
install_path='/opt/flight-direct'
build_path="$install_path/build"
ruby_version='ruby-2.5.1'
bundler_version='bundler-1.11.2'

# Install required yum packages
yum -y -e0 install git zlib zlib-devel

# Sets the git_url from the server address
project_path='alces-software/flight-direct.git'
if [ -z "$FLIGHT_DIRECT_SERVER" ]; then
  git_address="https://github.com/$project_path"
else
  git_address="http://$FLIGHT_DIRECT_SERVER/$project_path"
fi

# Installs the git repo
git clone "$git_address" "$install_path"

# Sets the ruby binary path
if [ -z "$FLIGHT_DIRECT_SERVER" ]; then
  ruby_url="https://cache.ruby-lang.org/pub/ruby/2.5/$ruby_version.tar.gz"
  bundler_url="https://rubygems.org/downloads/$bundler_version.gem"
else
  echo "NotImplementedError"
  exit 1
fi

# Downloads ruby
mkdir -p "$build_path/ruby"
cd "$build_path/ruby"
curl -o "ruby.tar.gz" "$ruby_url"

# Extracts ruby
tar -xvf "ruby.tar.gz"

# Installs ruby
cd "$ruby_version"
./configure --prefix="$install_path/opt/ruby" --enable-load-relative
make
make install

# Downloads Bundler
mkdir -p "$build_path/bundler"
cd "$build_path/bundler"
curl -o 'bundler.gem' $bundler_url

# Installs bundler
$install_path/opt/ruby/bin/gem install --local 'bundler.gem'

