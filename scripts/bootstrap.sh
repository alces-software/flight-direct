#!/bin/bash
# Must be the root user
if (( UID != 0 )); then
  echo "$0: must run as root"
  exit 1
fi

# Sets the install path variables
install_path='/opt/flight-direct'
ruby_dir="$install_path/vendor/ruby"
ruby_version='ruby-2.5.1'

# Sets the git_url from the server address
project_path='alces-software/flight-direct.git'
if [ -z "$FLIGHT_DIRECT_SERVER" ]; then
  git_address="https://github.com/$project_path"
else
  git_address="http://$FLIGHT_DIRECT_SERVER/$project_path"
fi

# Installs the git repo
yum -y -e0 install git
git clone "$git_address" "$install_path"

# Sets the ruby binary path
if [ -z "$FLIGHT_DIRECT_SERVER" ]; then
  ruby_url="https://cache.ruby-lang.org/pub/ruby/2.5/$ruby_version.tar.gz"
else
  echo "NotImplementedError"
  exit 1
fi

# Downloads ruby
mkdir -p "$ruby_dir"
cd "$ruby_dir"
curl -o "ruby.tar.gz" "$ruby_url"

# Extracts ruby
tar -xvf "ruby.tar.gz"

# Installs ruby
cd "$ruby_version"
./configure --prefix="$ruby_dir" --enable-load-relative
make
make install

# Remove the extracted ruby files
cd ..
rm -rf "$ruby_version"

