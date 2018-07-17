
module Loki
  module ThorExt
    def with_standard_help
      desc :help, 'Display help and usage information'
      define_method(:help) { |*a| super(*a) }
    end
  end
end
