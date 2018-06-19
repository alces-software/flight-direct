fd = 'FLIGHT_DIRECT'

# Sets the load path and development mode from the environment
dev_mode = (ENV["#{fd}_DEVELOPMENT_MODE"] == 'true')
default_root = ENV["#{fd}_ROOT"]
dev_root = ENV["#{fd}_RUBY_LOAD_ROOT"]
load_root = (dev_mode && dev_root) ? dev_root : default_root

# Adds the gems to the load path. `flight` uses a standalone installation
# which removes the run time dependency on Bundler. This prevents it
# changing the Bundler environment variables. This script takes the place
# of the `bundler` require
require "#{load_root}/bundle/bundler/setup"

# Sets up the load paths
$LOAD_PATH << File.join(load_root, 'lib', 'flight_direct')

# Adds additional debugging tools
require 'pry' if dev_mode

# NOTE: The `FlightDirect.root_dir` is always set to the `default_root`.
# FlightDirect is modular by nature and needs to know its install path. As
# such only the `FlightDirect` ruby code can be redirected, not the install
# itself.
module FlightDirect
  class << self
    def root_dir=(root)
      @root_dir ||= root.dup.freeze
    end
    attr_reader :root_dir
  end
end
FlightDirect.root_dir = default_root

# Requires the common gems used throughout the project
require 'active_support/core_ext/string'
require 'require_all'
require 'commands'

