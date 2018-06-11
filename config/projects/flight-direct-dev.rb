
# Loads the regular builds code into itself to ensure consistency in the builds
eval(File.read(File.join(Omnibus::Config.project_dir, 'flight-direct.rb')))

#
# Augments the normal build to be in development mode. Ruby is compiled with readline
# support.
#
flight_direct_overrides = (override("flight-direct") || {}).merge(development: true)
override "flight-direct", flight_direct_overrides

ruby_overrides = (override("ruby") || {}).merge(readline: true)
override "ruby", ruby_overrides

