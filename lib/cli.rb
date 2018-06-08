
require 'require_all'

require 'commander'
require 'commands'

module FlightDirect
  class CLI
    extend Commander::UI
    extend Commander::UI::AskForClass
    extend Commander::Delegates

    program :name, 'flight-direct'
    program :version, '0.0.0'
    program :description, 'Cluster Management Tool'

    # global_option('--debug', 'Enables the development mode')

    # suppress_trace_class UserError

    # Display the help if there is no input arguments
    ARGV.push '--help' if ARGV.empty?

    def self.action(command, klass)
      command.action { |args, opts| klass.new(args, opts).run! }
    end

    command :server do |c|
      c.syntax = 'flight server [options]'
      c.description = 'Manage the download server'
      c.sub_command_group = true
    end

    command :'server start' do |c|
      c.syntax = 'flight server start [options]'
      c.description = 'Starts the flight direct download server'
      c.hidden = true
      action(c, FlightDirect::Commands::Server::Start)
    end
  end
end
