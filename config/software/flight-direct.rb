
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

name "flight-direct"
# version "5.6.9"

source path: Omnibus::Config.project_root

dependency "ruby"
dependency "git"
dependency 'bundler'
dependency 'jq'
dependency 'jo'
dependency 'forge'

build do
  # Moves the project into place
  ['Gemfile', 'Gemfile.lock'].each do |file|
    copy "#{project_dir}/#{file}", "#{install_dir}/#{file}"
  end
  ['bin', 'etc', 'lib', 'scripts'].each do |sub_dir|
    sync "#{project_dir}/#{sub_dir}/", "#{install_dir}/#{sub_dir}/"
  end

  # Installs the gems to the shared `vendor/cache`
  dev_flag = "--with#{overrides[:development] ? '' : 'out'} development"
  path_flag = "--path #{install_dir}/vendor/cache"
  command "cd #{install_dir} && embedded/bin/bundle install #{path_flag} #{dev_flag}"

  # Removes `.bundle` directory. The `BUNDLE_PATH` will be set latter by `flight`
  delete("#{install_dir}/.bundle")

  # Set the development environment variable. This is used to bundle the ruby gems into the
  # project
  if overrides[:development]
    copy "#{project_dir}/development-mode.sh", "#{install_dir}/etc/profile.d"

  # The compiled version of ruby hard-codes the path to itself in:
  # embedded/bin/{gem, irb, ....}. This ensures those files always run with the version of
  # ruby they where installed with. However it means the files are no longer portable.
  # The fix is to `sed` the shebang to use what ever is on the path
  shebang = "#!#{embedded_bin('ruby')}"
  grep_cmd = "grep -rl '#{shebang}' #{install_dir}/*"
  sed_cmd = "sed -i 's:#{shebang}:#!/usr/bin/env ruby:g'"
  command "#{grep_cmd} | xargs -e #{sed_cmd}"
  end
end

