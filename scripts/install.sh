#!/bin/bash
#
# This scripts runs the Flight Direct installer
#
set -e

FL_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Sets up the profile
echo "source $FL_ROOT/etc/profile.sh" > /etc/profile.d/flight-direct.sh
source '/etc/profile.d/flight-direct.sh' >/dev/null

# Renders install time scripts
cat <<RENDER_SCRIPTS | flight ruby
require 'erb'
require 'fileutils'

template_dir = File.join(ENV['FL_ROOT'], 'templates/fl-root')
Dir.glob("#{template_dir}/**/*.erb")
   .each do |source|
     template = File.read(source)
     content = ERB.new(template, nil, '-').result(binding)
     destination = source.sub(template_dir, ENV['FL_ROOT']).chomp('.erb')
     FileUtils.mkdir_p File.dirname(destination)
     File.write(destination, content)
   end
RENDER_SCRIPTS

# Install Complete
cat <<EOF

FlightDirect has been successfully installed
Restart your current shell before continuing

EOF

