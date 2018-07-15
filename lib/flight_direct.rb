# Sets the load path and development mode from the environment
dev_mode = (ENV["FL_DEVELOPMENT_MODE"] == 'true')
default_root = ENV["FL_ROOT"]
dev_root = ENV["FL_RUBY_LOAD_ROOT"]
load_root = (dev_mode && dev_root) ? dev_root : default_root

# Sets up the load paths
$LOAD_PATH << File.join(load_root, 'lib')
$LOAD_PATH << File.join(load_root, 'lib', 'flight_direct')

# Sets up Bundler
ENV['BUNDLE_GEMFILE'] ||= "#{load_root}/Gemfile"
require 'bundler/setup'

# Requires the versioning info
require 'version'

# Adds additional debugging tools
if dev_mode
  require 'pry'
  require 'pry-byebug'
end

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

