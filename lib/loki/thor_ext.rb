
module Loki
  module ThorExt
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Just In Time, parse the subcommand. The subcommand code is only
      # loaded and added to Class after the CLI has selected it to run
      def jit_parse_subcommand(path, clean_bundle: false)
        cmd = extract_cmd_info(path)
        desc_method(cmd) do |*args|
          if clean_bundle
            Bundler.with_clean_env { parse_subcommand(cmd) }
          else
            parse_subcommand(cmd)
          end
        end
      end

      # Extracts the info in the block of code starting with '#: '
      # The '#' is optional
      def extract_cmd_info(path)
        cmd = OpenStruct.new
        File.read(path).each_line.map(&:chomp).each do |line|
          # The file stops being parsed on the first line without a '#:'
          break unless /\A[#:<]/.match?(line)
          # Filter out junk lines from the command declaration
          next unless /\A#?:\s(?!').*:\s.*/.match?(line)
          delim = (line[0] == '#' ? '#:' : ':')
          label = /(?<=\A#{delim}\s).*(?=:)/.match(line)[0]
          data = /(?<=\A#{delim}\s#{label}:\s).*/.match(line)[0]
          cmd[label.downcase.to_sym] = data
        end
        cmd.tap do |x|
          x[:path] = path
          x[:name] = File.basename(path, '.*')
        end
      end

      # Define a command with the additional error handling provided by loki
      # The provided block creates a special run method that is then wrapped
      # in the error handling. This way the class private methods are still
      # accessible
      def loki_command(method, &block)
        # Creates the special run method from the provided block
        no_commands do
          define_method(run_loki_method(method), &block)
          private run_loki_method(method)
        end
        # Creates the CLI command that calls the run method
        define_loki_command(method)
      end

      #
      # Equivalent of going def cmd.name .....
      # However it also describes the method first for Thor
      #
      def desc_method(cmd, &block)
        desc cmd.name, cmd.synopsis
        define_method(cmd.name, &block)
      end

      def run_loki_method(name)
        :"_run_loki_#{name}"
      end

      private

      # Loki commands allow for additional error handling then vanilla Thor
      def define_loki_command(method)
        method_option :trace, type: :boolean,
                      desc: 'Display the backtrace if there is an error'
        define_method(method) { |*args| run_loki_command(method, *args) }
      end
    end

    def parse_subcommand(cmd)
      thor = Loki::Parser.file(cmd.path)
      self.class.subcommand(cmd.name, thor)
      thor.start(args)
    end

    private

    def run_loki_command(method, *args)
        send(self.class.run_loki_method(method), *args)
    rescue NoMethodError, ArgumentError => e
      # Hide the `_run_loki` method from the inbuilt Thor error handlers
      # Thor checks the backtrace to see where the error occurs
      # TODO: Make the safer and probably test it
      e.backtrace.shift
      raise e
    rescue => e
      # Reraise the error if the backtrace is on
      raise e if options.trace
      $stderr.puts "ERROR: #{e.message}\nUse --trace to show the backtrace"
    end
  end
end
