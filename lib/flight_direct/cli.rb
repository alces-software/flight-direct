
require 'thor'

module FlightDirect
  class CLI < Thor
    class << self
      alias_method :run!, :start
    end

    desc 'new', 'hello world'
    def new(*args)
      puts args
    end

    private
  end
end
