
# Sets up the load paths
module FlightDirect
  def self.root_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end

$LOAD_PATH << File.join(FlightDirect.root_dir, 'lib/flight_direct')

# Sets up bundler
require 'bundler'
require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.join(FlightDirect.root_dir, 'Gemfile')

if ENV['FLIGHT_DIRECT_DEVELOPMENT_MODE'] == 'true'
  Bundler.setup(:default, :development)
  require 'pry'
else
  Bundler.setup(:default)
end

# Requires the common gems used throughout the project
require 'active_support/core_ext/string'
require 'require_all'
require 'commands'

