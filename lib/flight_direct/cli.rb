
require 'thor'

module FlightDirect
  class CLI < Thor
    class << self
      alias_method :run!, :start
    end

    desc 'new', 'hello world'
    def new(*args)
      puts FlightDirect.root_dir
    end

    private
  end
end
