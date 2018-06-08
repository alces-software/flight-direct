require 'optparse'
require 'commander/patches/implicit-short-tags'
require 'commander/patches/decimal-integer'
require 'commander/patches/validate_inputs'

OptionParser.prepend Commander::Patches::ImplicitShortTags
OptionParser.prepend Commander::Patches::DecimalInteger

module Commander
  class Command
    prepend Patches::ValidateInputs

    attr_accessor :name, :examples, :syntax, :description
    attr_accessor :summary, :proxy_options, :options, :hidden
    attr_reader :sub_command_group

    alias sub_command= hidden=
    alias sub_command hidden

    ##
    # Options struct.

    class Options
      include Blank

      def initialize
        @table = {}
      end

      def __hash__
        @table
      end

      def method_missing(meth, *args)
        meth.to_s =~ /=$/ ? @table[meth.to_s.chop.to_sym] = args.first : @table[meth]
      end

      def default(defaults = {})
        @table = defaults.merge! @table
      end

      def inspect
        "<Commander::Command::Options #{ __hash__.map { |k, v| "#{k}=#{v.inspect}" }.join(', ') }>"
      end
    end

    ##
    # Initialize new command with specified _name_.

    def initialize(name)
      @name, @examples, @when_called = name.to_s, [], []
      @options, @proxy_options = [], []
    end

    ##
    # Add a usage example for this command.
    #
    # Usage examples are later displayed in help documentation
    # created by the help formatters.
    #
    # === Examples
    #
    #   command :something do |c|
    #     c.example "Should do something", "my_command something"
    #   end
    #

    def example(description, command)
      @examples << [description, command]
    end

    ##
    # Add an option.
    #
    # Options are parsed via OptionParser so view it
    # for additional usage documentation. A block may optionally be
    # passed to handle the option, otherwise the _options_ struct seen below
    # contains the results of this option. This handles common formats such as:
    #
    #   -h, --help          options.help           # => bool
    #   --[no-]feature      options.feature        # => bool
    #   --large-switch      options.large_switch   # => bool
    #   --file FILE         options.file           # => file passed
    #   --list WORDS        options.list           # => array
    #   --date [DATE]       options.date           # => date or nil when optional argument not set
    #
    # === Examples
    #
    #   command :something do |c|
    #     c.option '--recursive', 'Do something recursively'
    #     c.option '--file FILE', 'Specify a file'
    #     c.option('--info', 'Display info') { puts "handle with block" }
    #     c.option '--[no-]feature', 'With or without feature'
    #     c.option '--list FILES', Array, 'List the files specified'
    #
    #     c.when_called do |args, options|
    #       do_something_recursively if options.recursive
    #       do_something_with_file options.file if options.file
    #     end
    #   end
    #
    # === Help Formatters
    #
    # This method also parses the arguments passed in order to determine
    # which were switches, and which were descriptions for the
    # option which can later be used within help formatters
    # using option[:switches] and option[:description].
    #
    # === Input Parsing
    #
    # Since Commander utilizes OptionParser you can pre-parse and evaluate
    # option arguments. Simply require 'optparse/time', or 'optparse/date', as these
    # objects must respond to #parse.
    #
    #   c.option '--time TIME', Time
    #   c.option '--date [DATE]', Date
    #

    def option(*args, &block)
      default = nil
      args.delete_if do |v|
        if v.is_a?(Hash) && v.key?(:default)
          default = v[:default]
          true
        else
          false
        end
      end
      switches, description = Runner.separate_switches_from_description(*args)
      proc = block || option_proc(switches)
      @options << {
        args: args,
        proc: proc,
        switches: switches,
        description: description,
      }.tap { |h| h.merge!({ default: default }) unless default.nil? }
    end

    ##
    # Handle execution of command. The handler may be a class,
    # object, or block (see examples below).
    #
    # === Examples
    #
    #   # Simple block handling
    #   c.when_called do |args, options|
    #      # do something
    #   end
    #
    #   # Create inst of Something and pass args / options
    #   c.when_called MyLib::Command::Something
    #
    #   # Create inst of Something and use arbitrary method
    #    c.when_called MyLib::Command::Something, :some_method
    #
    #   # Pass an object to handle callback (requires method symbol)
    #   c.when_called SomeObject, :some_method
    #

    def when_called(*args, &block)
      fail ArgumentError, 'must pass an object, class, or block.' if args.empty? && !block
      @when_called = block ? [block] : args
    end
    alias action when_called

    ##
    # Handles displaying subcommand help. By default it will set the action to 
    # display the subcommand if the action hasn't already been set

    def sub_command_group=(value)
      @sub_command_group = value
      if @when_called.empty?
        self.action {
          exec("#{$0} #{ARGV.join(" ")} --help")
        }
      end
    end

    ##
    # Run the command with _args_.
    #
    # * parses options, call option blocks
    # * invokes when_called proc
    #

    def run(*args)
      call parse_options_and_call_procs(*args)
    end

    #:stopdoc:

    ##
    # Parses options and calls associated procs,
    # returning the arguments remaining.

    def parse_options_and_call_procs(*args)
      opt = @options.each_with_object(OptionParser.new) do |option, opts|
        opts.on(*option[:args], &option[:proc])
        opts
      end
      default_opt = @options.each_with_object([]) do |h, arr|
        if h.key?(:default)
          arr.push(h[:switches][0].split[0])
          arr.push(h[:default].to_s)
        end
      end
      opt.parse! default_opt
      opt.parse! args
    end

    ##
    # Call the commands when_called block with _args_.

    def call(args = [])
      object = @when_called.shift
      meth = @when_called.shift || :call
      options = proxy_option_struct
      case object
      when Proc then object.call(args, options)
      when Class then meth != :call ? object.new.send(meth, args, options) : object.new(args, options)
      else object.send(meth, args, options) if object
      end
    end

    ##
    # Creates an Options instance populated with the option values
    # collected by the #option_proc.

    def proxy_option_struct
      proxy_options.each_with_object(Options.new) do |(option, value), options|
        # options that are present will evaluate to true
        value = true if value.nil?
        options.__send__ :"#{option}=", value
        options
      end
    end

    ##
    # Option proxy proc used when a block is not explicitly passed
    # via the #option method. This allows commander to auto-populate
    # and work with option values.

    def option_proc(switches)
      ->(value) { proxy_options << [Runner.switch_to_sym(switches.last), value] }
    end

    def inspect
      "<Commander::Command:#{name}>"
    end
  end
end
