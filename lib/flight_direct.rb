
# Sets up the load paths
root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH << File.join(root_dir, 'lib/flight_direct')

# Sets up bundler
require 'bundler'
require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.join(root_dir, 'Gemfile')
Bundler.setup(:default)

# Requires the common gems used throughout the project
require 'active_support/core_ext/string/inflections'
require 'require_all'
require 'commands'

