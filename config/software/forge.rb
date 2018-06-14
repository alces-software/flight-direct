
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

name "forge"
version 'master'

source git: 'https://github.com/alces-software/forge-cli'

dependency "ruby"
dependency 'bundler'
dependency 'unzip'

build do
  # Moves forge into `opt/forge`
  forge_dir = "#{install_dir}/opt/forge"
  mkdir forge_dir
  ['Gemfile', 'Gemfile.lock'].each do |file|
    copy "#{project_dir}/#{file}", "#{forge_dir}/#{file}"
  end
  ['bin', 'lib'].each do |sub_dir|
    sync "#{project_dir}/#{sub_dir}/", "#{forge_dir}/#{sub_dir}/"
  end

  # Installs the gems to the shared `vendor/cache`
  flags = [
    '--no-cache',
    "--path #{install_dir}/vendor/gems"
  ].join(' ')
  command "cd #{forge_dir} && #{embedded_bin('bundle')} install #{flags}"

  # Removes the `.bundle` file. The BUNDLE_PATH will be set as an environment variable
  delete "#{forge_dir}/.bundle"
end

