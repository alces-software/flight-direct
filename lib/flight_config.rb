
module FlightConfig
  PREFIX = 'FL_CONFIG_'.freeze

  class << self
    def get(key)
      ENV[key_to_env(key)]
    end

    def key_to_env(key)
      PREFIX.dup + key.gsub('-', '_').upcase
    end
  end
end
