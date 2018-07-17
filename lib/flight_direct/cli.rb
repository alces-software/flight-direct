
require 'thor'
require 'ostruct'
require 'erb'

require 'loki'

module FlightDirect
  class CLI < Thor
    extend Loki::ThorExt

    class << self
      alias_method :run!, :start

      def glob_libexec(relative_path)
        Dir.glob(
          File.join(FlightDirect.root_dir, 'libexec', relative_path)
        )
      end

      def define_command(cmd, &block)
        desc cmd.name, cmd.synopsis
        define_method(cmd.name, &block)
      end
    end

    # Defines the contents of `libexec/actions` as commands
    # `*args` is used as it contains all arguments including flags
    # It also means the inbuilt `options` hash is empty
    glob_libexec('actions/**/*').each do |path|
      cmd = extract_cmd_info(path)
      define_command(cmd) { |*args| exec_action(cmd.path, *args) }
    end

    # Defines the Thor plugin commands using Loki
    glob_libexec('thor/*').each do |path|
      cmd = extract_cmd_info(path)
      define_command(cmd) { |*args| run_thor_plugin(cmd, *args) }
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

    def run_thor_plugin(cmd, *args)
      Bundler.with_clean_env do
        thor = Loki::Parser.file(cmd.path)
        self.class.subcommand(cmd.name, thor)
        thor.start(args)
      end
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

