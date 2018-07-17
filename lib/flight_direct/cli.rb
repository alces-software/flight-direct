
require 'thor'
require 'ostruct'
require 'erb'

require 'loki'

module FlightDirect
  class CLI < Thor
    class << self
      alias_method :run!, :start

      def actions_info
        action_paths.map { |path| extract_info(path) }
      end

      private

      def action_paths
        [FlightDirect.root_dir, ENV['cw_ROOT']].map do |root|
          Dir.glob(File.join(root, 'libexec/actions/**/*'))
        end.flatten
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
    # `*args` is used as it contains all arguments including flags
    # It also means the inbuilt `options` hash is empty
    actions_info.each do |cmd|
      desc cmd.name, cmd.synopsis
      define_method(cmd.name) { |*args| exec_action(cmd.path, *args) }
    end

    # Overrides the help command. Only display the help for the root,
    # `flight`, command. Otherwise re-execute with a --help flag
    def help(*all_args)
      command = all_args.reject { |a| /\A-/.match?(a) }
                        .first
      command ? invoke(command, [], help: true) : super
    end

    desc :version, 'Gives the Flight Direct version'
    def version
      puts FlightDirect::VERSION
    end

    private

    # Typically the thor `options` are empty for the action commands.
    # This is because the commands are defined with `*args` inputs which
    # contain the options already.
    # However when the overridden `help` method "invokes" other commands,
    # the "help" flag ends up in the options. For this reason, only the
    # help is flag is appended.
    # All other flags should be implicitly handled already
    def exec_action(path, *args)
      append_help = (options['help'] ? '--help' : '')
      flags = '--norc --noprofile'
      cmd =[
        'bash', flags, path, stringify_args(args), append_help
      ].join(' ')
      Bundler.with_clean_env { exec(cmd) }
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

