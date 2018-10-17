# Sets the load path and development mode from the environment
dev_mode = (ENV["FL_DEVELOPMENT_MODE"] == 'true')
default_root = ENV["FL_ROOT"]
dev_root = ENV["FL_RUBY_LOAD_ROOT"]
load_root = (dev_mode && dev_root) ? dev_root : default_root

# Sets up the load paths
$LOAD_PATH << File.join(load_root, 'lib')

# Bundler is explicitly NOT used to at runtime. Instead a --standalone
# setup file is generated at build time. This allows Bundler to be used
# by a forge-package within the same ruby process
setup_path = File.join(ENV['FL_ROOT'],
                       'vendor/share/bundler/flight-direct-setup.rb')
require_relative setup_path

# Requires the versioning info
require 'flight_direct/version'

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

