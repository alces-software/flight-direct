
module FlightDirect
  module Commands
    module Server
      class Create < Command
        def run
          `cat #{FlightDirect.root_dir}/scripts/start-git-http.sh | /bin/bash`
        end
      end
    end
  end
end
