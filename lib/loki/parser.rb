
module Loki
  module Parser
    def self.file(path)
      Class.new(Thor) do
        include ThorExt
        class_eval(File.read(path), path)
      end
    end
  end
end
