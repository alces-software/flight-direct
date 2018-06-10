

#
# Created using the help off:
# http://blog.scoutapp.com/articles/2013/06/21/omnibus-tutorial-package-a-standalone-ruby-gem
#
# Also  see:
# https://github.com/scoutapp/omnibus-scout
#

name "flight_diect"
# version "5.6.9"

# dependency "ruby"
# dependency "rubygems"

build do
  ['bin', 'lib', 'scripts'].each do |sub_dir|
    sync "#{Omnibus::Config.project_root}/#{sub_dir}/**/*", "#{install_dir}/#{sub_dir}"
  end
end

# build do
#   gem "install scout -n #{install_dir}/bin --no-rdoc --no-ri -v #{version}"
#   command "rm -rf /opt/scout/embedded/docs"
#   command "rm -rf /opt/scout/embedded/share/man"
#   command "rm -rf /opt/scout/embedded/share/doc"
#   command "rm -rf /opt/scout/embedded/ssl/man"
#   command "rm -rf /opt/scout/embedded/info"
# end

