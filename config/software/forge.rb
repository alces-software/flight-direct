
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
default_version '0.0.3'

source git: 'https://github.com/alces-software/forge-cli'

dependency "ruby"
dependency 'bundler'
dependency 'unzip'

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

  # Moves forge into `opt/forge`
  forge_dir = "#{install_dir}/opt/forge"
  mkdir forge_dir
  ['Gemfile', 'Gemfile.lock'].each do |file|
    copy "#{project_dir}/#{file}", "#{forge_dir}/#{file}"
  end
  ['bin', 'lib'].each do |sub_dir|
    sync "#{project_dir}/#{sub_dir}/", "#{forge_dir}/#{sub_dir}/"
  end

  # Move the `forge` action into the `FlightDirect` cli
  sync "#{project_dir}/libexec", "#{install_dir}/libexec"

  # Installs the gems to the shared `vendor/cache`
  command "cd #{forge_dir} && #{embedded_bin('bundle')} install", env: env
end

