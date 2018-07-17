
module Loki
  module ThorExt
    # Extracts the info in the block of code starting with '#: '
    # The '#' is optional
    def extract_cmd_info(path)
      cmd = OpenStruct.new
      File.read(path).each_line.map(&:chomp).each do |line|
        # The file stops being parsed on the first line without a '#:'
        break unless /\A#?[:!]/.match?(line)
        # Filter out junk lines (see legacy code)
        # Shebangs are allowed pass the break but are filtered out here
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
  end
end
