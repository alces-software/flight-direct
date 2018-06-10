source 'https://rubygems.org'

gem 'activesupport'
gem 'commander', git: 'https://github.com/alces-software/commander'
gem 'require_all'

gem 'pry'
gem 'pry-byebug'

# Testing out omnibus as an install mechanism, the test-kitchen stuff has been
# commented out as it is more advanced features
gem 'omnibus', '~> 5.6'
gem 'omnibus-software', :git => 'git://github.com/opscode/omnibus-software.git', :branch => 'master'

# Use Chef's software definitions. It is recommended that you write your own
# software definitions, but you can clone/fork Chef's to get you started.
# gem 'omnibus-software', github: 'opscode/omnibus-software'

# This development group is installed by default when you run `bundle install`,
# but if you are using Omnibus in a CI-based infrastructure, you do not need
# the Test Kitchen-based build lab. You can skip these unnecessary dependencies
# by running `bundle install --without omnibus_development` to speed up build times.

group :omnibus_development do
  # Use Berkshelf for resolving cookbook dependencies
  # gem 'berkshelf', '~> 3.3'

  # Use Test Kitchen with Vagrant for converging the build environment
  # gem 'test-kitchen',    '~> 1.4'
  # gem 'kitchen-vagrant', '~> 0.18'
end

