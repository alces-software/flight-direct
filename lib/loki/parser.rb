
module Loki
  module Parser
    def self.file(path)
      Class.new(Thor) { class_eval(File.read(path)) }
    end
  end
end
