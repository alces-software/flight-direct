
#
# Created using the help off:
# http://blog.scoutapp.com/articles/2013/06/21/omnibus-tutorial-package-a-standalone-ruby-gem
#
# Also  see:
# https://github.com/scoutapp/omnibus-scout
#
# For reference on how to build from source, see `omnibus-gitlab`:
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/config/software/gitlab-cookbooks.rb
# NOTE: Ignore the `chef-cookbook` stuff for now, that is an extension off `omnibus`
#

require_relative File.join(
  Omnibus::Config.project_root, 'lib', 'flight_direct', 'version.rb'
)

name "flight-direct"
default_version FlightDirect::VERSION

if overrides[:version] == 'local'
  source path: Omnibus::Config.project_root
else
  source git: 'https://github.com/alces-software/flight-direct'
end

dependency "ruby"
dependency "git"
dependency 'bundler'
dependency 'jq'
dependency 'jo'
dependency 'forge'
dependency 'uuid'

build do
  # Deletes any pre-existing bundle configs as the gems need to be installed
  # in a specific way
  delete "#{project_dir}/.bundle"

  gem_home = "#{install_dir}/vendor/share"
  mkdir gem_home
  env = with_standard_compiler_flags(with_embedded_path({
    "GEM_HOME" => gem_home,
    "GEM_PATH" => gem_home,
    "BUNDLE_PATH" => gem_home
  }))

  # Moves the project into place
  ['Gemfile', 'Gemfile.lock'].each do |file|
    copy "#{project_dir}/#{file}", "#{install_dir}/#{file}"
  end
  dirs = [
    'bin', 'etc', 'lib', 'libexec', 'opt', 'scripts'
  ]
  dirs.each do |sub_dir|
    copy "#{project_dir}/#{sub_dir}",
         File.expand_path("#{install_dir}/#{sub_dir}/../")
  end

  # Installs the gems to the shared `vendor/gems/--some-where-?--`
  flags = [
    '--standalone',
    "--with#{overrides[:development] ? '' : 'out'} development"
  ].join(' ')
  command "cd #{install_dir} && embedded/bin/bundle install #{flags}", env: env
  move "#{gem_home}/bundler/setup.rb", "#{gem_home}/bundler/flight-setup.rb"

  # Set the development environment variable. This is used to bundle the ruby gems into the
  # project
  if overrides[:development]
    copy "#{project_dir}/development-mode.sh", "#{install_dir}/etc/profile.d"
  end

  cw_root = "#{install_dir}/opt/clusterware"
  command "cd #{cw_root} && #{embedded_bin('bundle')} install", env: env

  # The compiled version of ruby hard-codes the path to itself in:
  # embedded/bin/{gem, irb, ....}. This ensures those files always run with the version of
  # ruby they where installed with. However it means the files are no longer portable.
  # The fix is to `sed` the shebang to use what ever is on the path
  shebang = "#!#{embedded_bin('ruby')}"
  grep_cmd = "grep -rl '#{shebang}' #{install_dir}/*"
  sed_cmd = "sed -i 's:#{shebang}:#!/usr/bin/env ruby:g'"
  command "#{grep_cmd} | xargs -e #{sed_cmd}"
end

