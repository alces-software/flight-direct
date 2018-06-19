
require 'thor'

module FlightDirect
  class CLI < Thor
    class << self
      alias_method :run!, :start

      def actions_hash
        action_paths.map do |path|
          [File.basename(path, '.*'), path]
        end.to_h
      end

      private

      def action_paths
        Dir.glob(File.join(FlightDirect.root_dir, 'libexec/actions/**/*'))
      end
    end

    # Defines the contents of `libexec/actions` as commands
    actions_hash.each do |action, path|
      desc action, "Run: #{action}"
      define_method(action) { |*args| exec_action(path, *args) }
    end

    private

    def exec_action(path, *args)
      exec("bash #{path}")
    end
  end
end
