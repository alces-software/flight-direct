#: '
#: SYNOPSIS: Manage the Flight Direct config
#: '

# SYNOPSIS DECLARATION:
# The above SYNOPSIS declaration is a flag to FlightDirect core CLI. It
# allows for details of the package to be parsed without having to require
# the ruby code. This will make the CLI faster as it only requires the code
# if it is going to run it. It is unrelated to the thor-loki stuff below.
# STYLE: Please leave a empty line after the declaration
#
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
# Loki will also add a few helper methods, the first when being
# `with_standard_help`. The help functionality will need to be expand at
# some point, so having the command will be useful. Loki is currently a WIP
#
# * Thor and Loki are implicitly available, however other packages will
#   still need to be required

require 'json'
require 'erb'
PREFIX = 'FL_CONFIG_'.freeze

with_standard_help

desc 'set key1=value1 k2=v2 ...', 'Set Flight Direct config values'
def set(*jo_inputs)
  cli_hash = parse_jo_input(*jo_inputs)
  new_configs = hash_to_config_envs(cli_hash)
  export_configs(new_configs)
end

private

def parse_jo_input(*input)
  JSON.parse(`jo #{input.join(' ')}`)
end

def hash_to_config_envs(params)
  params.map do |key, value|
    config_key = PREFIX.dup + key.gsub('-', '_').upcase
    [config_key, (value.nil? ? '' : value)]
  end.to_h
end

CONFIG_TEMPLATE = <<CONF
#!/bin/bash
#
# This file is managed by Flight Direct and stores the user defined
# environment configs ('FL_CONFIG'). This file may be editted with
# `flight config set` or manually
#
# NOTE: Editting Manually
# All variabels must be prefixed with `FL_CONFIG_`. Failure to do so will
# cause the config to be lost the next time the file is editted through
# `flight config`
#
<% fl_configs.each do |key, value| -%>
<%= key %>=<%= value %>
<% end -%>
CONF

def export_configs(new_configs = {})
  new_configs.map do |env_key, value|
    ENV[env_key] = value.to_s
  end
  # fl_configs is used to render the template
  fl_configs = ENV.select { |k, _v| /\A#{PREFIX}/.match?(k) }
  config_content = ERB.new(CONFIG_TEMPLATE, nil, '-').result(binding)
  config_path = File.join(FlightDirect.root_dir, 'var/flight.conf')
  File.write(config_path, config_content)
end

