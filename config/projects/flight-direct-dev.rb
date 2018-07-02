
# Loads the regular builds code into itself to ensure consistency in the builds
eval(File.read(File.join(Omnibus::Config.project_dir, 'flight-direct.rb')))

# Use the build iteration to mark the release as dev
build_iteration 'dev'

#
# Augments the normal build to be in development mode. Ruby is compiled with readline
# support.
#
fd_overrides = (override("flight-direct") || {}).merge(
  development: true,
  version: 'local'
)
override "flight-direct", fd_overrides

ruby_overrides = (override("ruby") || {}).merge(readline: true)
override "ruby", ruby_overrides

