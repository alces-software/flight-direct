
require 'thor'

module FlightDirect
  class CLI < Thor
    desc 'new', 'hello world'
    def new(*args)
      puts args
    end

    private
  end
end

FlightDirect::CLI.start(ARGV)
