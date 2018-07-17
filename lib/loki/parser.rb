
module Loki
  module Parser
    def self.file(path)
      Class.new(Thor) do
        extend Loki::ThorExt
        class_eval(File.read(path))
      end
    end
  end
end
