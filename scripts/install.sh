#!/bin/bash
#
# This scripts runs the Flight Direct installer
#
set -e

FL_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Source flight so it can use ERB
source $FL_ROOT/etc/profile.sh >/dev/null

cat <<RUBY_SCRIPT | flight ruby
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

# Renders the templates that are stored within the flight root
fl_root_templates = File.join(ENV['FL_ROOT'], 'templates/fl-root')
render.directory(fl_root_templates, ENV['FL_ROOT'])

# Renders the distibutes (aka root) templates
dist_templates = File.join(ENV['FL_ROOT'], 'templates/dist')
render.directory(dist_templates, '/')

# Creates the reboot crontab directory. The system entry is created in the
# distibution file rendering
FileUtils.mkdir_p File.join(ENV['FL_ROOT'], 'etc/cron.reboot')

# Renders the cron files from the shared directory. We need a better way
# do this. Maybe the file syncer once I write it ??
template_file = File.join(ENV['FL_ROOT'], 'templates/share/cron.time.erb')
template = File.read(template_file)
['hourly', 'daily', 'weekly', 'monthly'].each do |cron_time|
  rendered = ERB.new(template, nil, '-').result(binding)
  cron_path = "/etc/cron.#{cron_time}"
  cron_file = File.join(cron_path, 'flight-direct')
  File.write(cron_file, rendered)
  FileUtils.chmod 0644, cron_file
  FileUtils.mkdir_p File.join(ENV['FL_ROOT'], cron_path)
end
RUBY_SCRIPT

# Install Complete
cat <<EOF

Flight Direct has been successfully installed
Restart your current shell before continuing

EOF

