
require 'commander'

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

    command :server do |c|
      c.syntax = 'flight server [options]'
      c.description = 'Manage the download server'
      c.sub_command_group = true
    end
  end
end
