
require 'thor'
require 'ostruct'

module FlightDirect
  class CLI < Thor
    class << self
      alias_method :run!, :start

      def actions_info
        action_paths.map { |path| extract_info(path) }
      end

      private

      def action_paths
        Dir.glob(File.join(FlightDirect.root_dir, 'libexec/actions/**/*'))
      end

      # Extracts the info block contained at the top of the action files
      def extract_info(path)
        cmd = OpenStruct.new(path: path)
        File.read(path).each_line.map(&:chomp).each do |line|
          # Only match lines that start with `: `
          # However skip any lines that start with `: '`
          # The loop is stopped once the name and synopsis have been set
          break if cmd.name && cmd.synopsis
          next unless /\A:\s(?!').*:\s.*/.match?(line)
          label = /(?<=\A:\s).*(?=:)/.match(line)[0]
          data = /(?<=:\s#{label}:\s).*/.match(line)[0]
          cmd[label.downcase.to_sym] = data
        end
        cmd
      end
    end

    # Defines the contents of `libexec/actions` as commands
    actions_info.each do |cmd|
      desc cmd.name, cmd.synopsis
      define_method(cmd.name) { |*args| exec_action(cmd.path, *args) }
    end

    private

    def exec_action(path, *args)
      exec("bash #{path} " + stringify_args(args))
    end

    # The argument array needs to be converted back to a space separated
    # list. However any strings containing a \n, need to be encapsulated
    # in quotes. This should hopefully keep them together
    def stringify_args(args)
      args.map { |s| s.include?("\s") ? "'#{s}'" : s }
          .join(" ")
    end
  end
end
