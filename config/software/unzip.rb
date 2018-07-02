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

name "unzip"
default_version "6.0"

relative_path "unzip#{version.tr('.', '')}"
source url: "https://sourceforge.net/projects/infozip/files/#{relative_path}.tar.gz"

version('6.0') { source md5: '62b490407489521db863b523a7f86375' }

# license "Zlib"
# license_file "README"
# skip_transitive_dependency_licensing true

build do
  make '-f unix/Makefile generic'
  make "prefix=#{install_dir}/embedded -f unix/Makefile install"
end
