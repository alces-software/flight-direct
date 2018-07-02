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

name "jq"
default_version "1.5"

source url: "https://github.com/stedolan/jq/releases/download/jq-#{version}/jq-linux64"

version('1.5') { source sha256: "c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d" }

# license "Zlib"
# license_file "README"
# skip_transitive_dependency_licensing true

relative_path "jq-#{version}"

build do
  bin_path = embedded_bin('jq')
  copy "#{project_dir}/jq-linux64", bin_path
  command "chmod 755 #{bin_path}"
end
