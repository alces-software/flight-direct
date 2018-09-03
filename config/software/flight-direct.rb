
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
dependency 'libgit2'
dependency 'bundler'
dependency 'jq'
dependency 'jo'
dependency 'forge'

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
  [
    'Gemfile', 'Gemfile.lock', 'bin', 'etc', 'lib', 'libexec', 'scripts',
    'templates'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Makes required install directories
  [
    'etc/motd.d', 'etc/modules/services', 'var/lib', 'var/log', 'opt'
  ].each do |rel_path|
    mkdir File.join(install_dir, rel_path)
  end

  # Moves the distribution specific files into place
  cw_DIST = centos? ? 'el7' : (raise <<~EOF.squish
      FlightDirect can currently only be built for el7
    EOF
  )

  # Only the files within the `dist/$cw_DIST` directory should be
  # sycned. Thus the directory needs to be globbed for it's contents
  # at build time
  block do
    Dir.glob(
      File.join(project_dir, 'dist', cw_DIST, '*')
    ).each { |path| copy path, install_dir }
  end

  # Replace ME!!!
  erb source: 'dist-runtime.sh.erb',
      dest: "#{install_dir}/etc/dist-runtime.sh",
      mode: 0664,
      vars: { cw_DIST: cw_DIST }

  # Installs the gems to the shared `vendor/gems/--some-where-?--`
  flags = [
    "--with#{overrides[:development] ? '' : 'out'} development"
  ].join(' ')
  command "cd #{install_dir} && embedded/bin/bundle install #{flags}", env: env

  # Set the development environment variable
  if overrides[:development]
    copy "#{project_dir}/ZZ-development-mode.sh",
         "#{install_dir}/etc/profile.d"
  end

  # The compiled version of ruby hard-codes the path to itself in:
  # embedded/bin/{gem, irb, ....}. This ensures those files always run with the version of
  # ruby they where installed with. However it means the files are no longer portable.
  # The fix is to `sed` the shebang to use what ever is on the path
  shebang = "#!#{embedded_bin('ruby')}"
  grep_cmd = "grep -rl '#{shebang}' #{install_dir}/*"
  sed_cmd = "sed -i 's:#{shebang}:#!/usr/bin/env ruby:g'"
  command "#{grep_cmd} | xargs -e #{sed_cmd}"
end

