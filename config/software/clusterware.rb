
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
default_version 'develop'

source git: 'https://github.com/alces-software/clusterware'

build do
  clusterware_dir = "#{install_dir}/opt/clusterware"
  mkdir clusterware_dir
  copy "#{project_dir}/lib/clusterware.kernel.sh",
       "#{clusterware_dir}/clusterware.kernel.sh"
  sync "#{project_dir}/lib/functions", "#{clusterware_dir}/lib/functions"
end

