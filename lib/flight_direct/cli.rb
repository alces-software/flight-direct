
require 'commander'

##
# Under development, there are some common features of Commander::Command which
# I would like to generalize. However until such time that the code stabilized, the
# new features will be defined here.

class Commander::Command
  ##
  # Auto runs all the default methods
  #
  def run_with_defaults(*command_args)
    default_syntax(*command_args)
    default_action
  end

  ##
  # Uses the commands "name" to build the command syntax
  # "PROGRAM_NAME COMMAND_NAME [ARGUMMENTS] [options]"
  # The syntax is construct as the following:
  #   1. It is prefixed by the program(:name) set in the CLI object
  #   2. Appends the command "name"
  #   3. Joins the arguments, "args", to the command (this is optional)
  #   4. Adds the "[options]" suffix which is always requried
  #
  def default_syntax(*args)
    argument_string = args.join(' ') + (args.empty? ? '' : ' ')
    self.syntax = "#{program(:name)} #{name} #{argument_string}[options]"
  end

  ##
  # Hooks into the new "command_module" attribute and appends the command "name"
  # This then converted to a constant which is used as the command class
  # The class is initialized with the arguments from Commander and then calls the `run!`
  # method
  #
  def default_action
    class_str = "#{program(:commands_module)}::#{name.split.map(&:capitalize).join('::')}"
    klass = class_str.constantize # Ensures the command exists when the CLI is parsed
    action { |*a| klass.new(*a).run! }
  end

  private

  def program(*args)
    Commander::Runner.instance.program(*args)
  end
end

module FlightDirect
  class CLI
    extend Commander::Delegates

    program :name, 'flight'
    program :version, '0.0.0'
    program :description, 'Cluster Management Tool'
    program :commands_module, 'FlightDirect::Commands'

    # global_option('--debug', 'Enables the development mode')

    # suppress_trace_class UserError

    # Display the help if there is no input arguments
    ARGV.push '--help' if ARGV.empty?

    command :server do |c|
      c.default_syntax
      c.description = 'Manage the download server'
      c.sub_command_group = true
    end

    command :'server create' do |c|
      c.run_with_defaults
      c.description = 'Starts the flight direct download server'
      c.hidden = true
    end
  end
end
