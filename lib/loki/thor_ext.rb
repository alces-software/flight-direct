
module Loki
  module ThorExt
    # Extracts the info block contained at the top of the action files
    def extract_cmd_info(path)
      cmd = OpenStruct.new
      File.read(path).each_line.map(&:chomp).each do |line|
        # Only match lines that start with `: `
        # However skip any lines that start with `: '`
        # The loop is stopped once the name and synopsis have been set
        break if cmd.synopsis
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
