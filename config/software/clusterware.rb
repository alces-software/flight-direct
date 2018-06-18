
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

name "clusterware"
default_version 'master'

source git: 'https://github.com/alces-software/clusterware'

build do
  clusterware_dir = "#{install_dir}/opt/clusterware"
  mkdir clusterware_dir
  sync "#{project_dir}/lib", clusterware_dir
end

