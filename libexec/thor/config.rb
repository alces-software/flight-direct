#: SYNOPSIS: Manage the Flight Direct config
#: ROOT: true

# IMPORTANT NOTE:
# The blank line above me denotes the end of the command declaration
# Because of the various other magic comments, the declaration is not
# guaranteed to be at the top.
#
# Instead the *BLANK LINE* is tells FlightDirect that this is the end of
# the declaration
#
# SYNOPSIS DECLARATION:
# The above SYNOPSIS declaration is a flag to FlightDirect core CLI. It
# allows for details of the package to be parsed without having to require
# the ruby code. This will make the CLI faster as it only requires the code
# if it is going to run it. It is unrelated to the thor-loki stuff below.

# THOR-LOKI:
# This file uses the new Loki module to generate a Thor file. Loki will
# create an anonymous Thor class and then evaluates the following code.
# This removes the boiler-plate require*/module/class declarations.
#
# See For More Details (about Thor):
# - http://whatisthor.com/
# - https://github.com/erikhuda/thor/wiki/Getting-Started
# - https://www.rubydoc.info/github/wycats/thor/Thor
#
# * Thor and Loki are implicitly available, however other packages will
#   still need to be required

require 'flight_config'
require 'json'
require 'erb'
CONFIG_PATH = File.join(FlightDirect.root_dir, 'var/flight.conf')

desc 'set KEY1=VALUE1 K2=V2 ...', 'Set Flight Direct config values'
long_desc <<-LONGDESC
The `config set` command manages the config environment variables that are
loaded at runtime. The keys will be converted to UPPER_SNAKE_CASE and
prefixed with `FL_CONFIG_`, making them case insensitive. The value is
stored in its raw format and needs to be bash friendly.

The empty string input (`key= ...`) will unset the key value. This
action will completely remove the key from the config file. However
the environment variable may still be set by the parant shell.
LONGDESC
loki_command(:set) do |*jo_inputs|
  cli_hash = parse_jo_input(*jo_inputs)
  new_configs = hash_to_config_envs(cli_hash)
  merged_configs = existing_configs.merge(new_configs)
                                   .reject { |_k, v| v.to_s.empty? }
  export_configs(merged_configs)
end

# Configs should always be retrieved from the environment. This makes
# them more flexible should things change in the future. The 'get'
# command is only a user friendly wrapper
desc 'get KEY', 'Retrieve a Flight Direct config value'
long_desc <<-LONGDESC
The `config get` returns a single config value for a give key. It will
preform the same string processesing on the key as `config set`.

Please note that the all config are read from the environment. See the
`config help list` command for more details.
LONGDESC
loki_command(:get) do |key|
  puts FlightConfig.get(key)
end

desc 'list', 'Lists all the configs loaded into the environment'
loki_command(:list) do
  ENV.select { |k, _v| /\A#{FlightConfig::PREFIX}/.match?(k) }
     .each { |k, v| puts "#{k}=#{v}" }
end

private

def parse_jo_input(*input)
  str = input.flatten.join(' ')
  return {} if str.empty?
  JSON.parse(`jo #{input.join(' ')}`) || {}
end

def hash_to_config_envs(params)
  params.map do |key, value|
    [FlightConfig.key_to_env(key), (value.nil? ? '' : value)]
  end.to_h
end

def existing_configs
  jo_str = read_config.each_line
                      .reject { |line| line[0] == '#' }
                      .map(&:chomp)
  parse_jo_input(jo_str)
end

def read_config
  return '' unless File.exist?(CONFIG_PATH)
  File.read(CONFIG_PATH)
end

CONFIG_TEMPLATE = <<CONF
#!/bin/bash
#
# This file is managed by Flight Direct and stores the user defined
# environment configs ('FL_CONFIG'). This file may be editted with
# `flight config set` or manually
#
# NOTE: Editing Manually
# All variables must be prefixed with `FL_CONFIG_`. Failure to do so will
# cause the config to be lost the next time the file is editted through
# `flight config`
#
<% fl_configs.each do |key, value| -%>
<%= key %>=<%= value %>
<% end -%>
CONF

# fl_configs is used to render the template
def export_configs(fl_configs)
  config_content = ERB.new(CONFIG_TEMPLATE, nil, '-').result(binding)
  File.write(CONFIG_PATH, config_content)
end

