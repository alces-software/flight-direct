#
# Adapted from the install routine for zlib from "Chef Software"
# https://raw.githubusercontent.com/chef/omnibus-software/master/config/software/zlib.rb
#

#
# Copyright 2012-2018 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "jo"
default_version "1.0"

source url: "https://github.com/jpmens/jo/releases/download/v#{version}/jo-#{version}.tar.gz"

version('1.0') { source sha256: "d66ec97258d1afad15643fb2d5b5e807153a732ba45c2417adc66669acbde52e" }

# license "Zlib"
# license_file "README"
# skip_transitive_dependency_licensing true

relative_path "jo-#{version}"

build do
  env = with_standard_compiler_flags
  configure env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
