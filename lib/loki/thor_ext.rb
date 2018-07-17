
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
          break unless /\A[#:]/.match?(line)
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

      #
      # Equivalent of going def cmd.name .....
      # However it also describes the method first for Thor
      #
      def desc_method(cmd, &block)
        desc cmd.name, cmd.synopsis
        define_method(cmd.name, &block)
      end
    end

    def parse_subcommand(cmd)
      thor = Loki::Parser.file(cmd.path)
      self.class.subcommand(cmd.name, thor)
      thor.start(args)
    end
  end
end
