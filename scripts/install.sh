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
    dest_path = File.join(dest_dir, rel_path).chomp('.erb')
    FileUtils.mkdir_p File.dirname(dest_path)
    File.write(dest_path, content)
  end
end

fl_root_templates = File.join(ENV['FL_ROOT'], 'templates/fl-root')
render.directory(fl_root_templates, ENV['FL_ROOT'])
dist_templates = File.join(ENV['FL_ROOT'], 'templates/dist')
render.directory(dist_templates, '/')

# Renders the cron files from the shared directory. We need a better way
# do this. Maybe the file syncer once I write it ??
template_file = File.join(ENV['FL_ROOT'], 'templates/share/cron.time.erb')
template = File.read(template_file)
['hourly', 'daily', 'weekly', 'monthly'].each do |cron_time|
  rendered = ERB.new(template, nil, '-').result(binding)
  cron_path = "/etc/cron.#{cron_time}"
  File.write("#{cron_path}/flight-direct", rendered)
  FileUtils.mkdir_p File.join(ENV['FL_ROOT'], cron_path)
end
RENDER_SCRIPTS

# Install Complete
cat <<EOF

FlightDirect has been successfully installed
Restart your current shell before continuing

EOF

