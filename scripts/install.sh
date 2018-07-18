#!/bin/bash
#
# This scripts runs the Flight Direct installer
#
set -e

FL_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Source flight so it can use ERB
source $FL_ROOT/etc/profile.sh >/dev/null

# Renders install time scripts
cat <<RENDER_SCRIPTS | flight ruby
require 'erb'
require 'fileutils'

render = Class.new do
  def self.directory(source, destination)
    Dir.glob(File.join(source, '**/*.erb'))
       .map { |path| path.sub(source, '') }
       .each { |path| file(source, destination, path) }
  end

  private

  def self.file(src_dir, dest_dir, rel_path)
    template = File.read(File.join(src_dir, rel_path))
    content = ERB.new(template, nil, '-').result(binding)
    FileUtils.mkdir_p dest_dir
    File.write(File.join(dest_dir, rel_path).chomp('.erb'), content)
  end
end

fl_root_templates = File.join(ENV['FL_ROOT'], 'templates/fl-root')
render.directory(fl_root_templates, ENV['FL_ROOT'])
dist_templates = File.join(ENV['FL_ROOT'], 'templates/dist')
render.directory(dist_templates, '/')
RENDER_SCRIPTS

# Install Complete
cat <<EOF

FlightDirect has been successfully installed
Restart your current shell before continuing

EOF

