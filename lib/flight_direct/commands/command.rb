
module FlightDirect
  module Commands
    class Command
      def initialize(_args, _options)
      end

      # The `run!` is used by the `CLI` to run the command, in the
      # future it will be responsible for setting up logging
      def run!
        run
      end

      private

      # Contains the command specific run code
      def run
        raise NotImplementedError
      end
    end
  end
end
