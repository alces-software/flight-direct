
# Only allow moving the source location in development mode
ENV["FLIGHT_DIRECT_RUBY_SOURCE"] = nil unless ENV["FLIGHT_DIRECT_DEVELOPMENT_MODE"] == 'true'

# The `RUBY_SOURCE` is the location the ruby code should be loaded from. This allows it
# to be moved during development
ENV["FLIGHT_DIRECT_RUBY_SOURCE"] ||= ENV['FLIGHT_DIRECT_ROOT']

# Sets up the load paths
$LOAD_PATH << File.join(ENV["FLIGHT_DIRECT_RUBY_SOURCE"], 'lib/flight_direct')

# Sets up bundler
require 'bundler'
require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.join(ENV["FLIGHT_DIRECT_RUBY_SOURCE"], 'Gemfile')

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

