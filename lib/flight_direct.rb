
# Sets the load path and development mode from the environment
development_mode = (ENV['FLIGHT_DIRECT_DEVELOPMENT_MODE'] == 'true')
load_root = ENV['FLIGHT_DIRECT_ROOT']

# Sets up the load paths
$LOAD_PATH << File.join(load_root, 'lib/flight_direct')
ENV['BUNDLE_GEMFILE'] = File.join(load_root, 'Gemfile')

# Sets up bundler
require 'bundler'
require 'rubygems'

if development_mode
  Bundler.setup(:default, :development)
  require 'pry'
else
  Bundler.setup(:default)
end

# Requires the common gems used throughout the project
require 'active_support/core_ext/string'
require 'require_all'
require 'commands'

