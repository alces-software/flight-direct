
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

name "flight_direct"
# version "5.6.9"

source path: Omnibus::Config.project_root

dependency "ruby"
dependency "git"
dependency 'bundler'

build do
  ['Gemfile', 'Gemfile.lock'].each do |file|
    copy "#{project_dir}/#{file}", "#{install_dir}/#{file}"
  end
  ['bin', 'lib', 'scripts'].each do |sub_dir|
    sync "#{project_dir}/#{sub_dir}/", "#{install_dir}/#{sub_dir}/"
  end
  command "cd #{install_dir} && embedded/bin/bundle package --all"
end

