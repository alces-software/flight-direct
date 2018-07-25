
module FlightConfig
  PREFIX = 'FL_CONFIG_'.freeze

  class << self
    def get(key, allow_missing: true)
      env = key_to_env(key)
      ENV[env].tap do |value|
        raise <<-ERROR if !(allow_missing || value)
'#{env}' has not been set. Please see 'flight config set' for more details
ERROR
      end
    end

    def key_to_env(key)
      PREFIX.dup + key.gsub('-', '_').upcase
    end
  end
end
