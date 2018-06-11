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

name "readline"
default_version "6.3"

version("6.3") { source sha256: "56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43" }

source url: "https://ftp.gnu.org/gnu/readline/readline-#{version}.tar.gz"

# license "Zlib"
# license_file "README"
# skip_transitive_dependency_licensing true

relative_path "readline-#{version}"

build do
  if windows?
    raise NotImplementedError
  else
    #
    # NOTE: `with_standard_compiler_flags` returns:
    # {"LDFLAGS"=>"-Wl,-rpath,/opt/flight-direct/embedded/lib -L/opt/flight-direct/embedded/lib",
    # "CFLAGS"=>"-I/opt/flight-direct/embedded/include -O2",
    # "LD_RUN_PATH"=>"/opt/flight-direct/embedded/lib",
    # "PKG_CONFIG_PATH"=>"/opt/flight-direct/embedded/lib/pkgconfig",
    # "CXXFLAGS"=>"-I/opt/flight-direct/embedded/include -O2",
    # "CPPFLAGS"=>"-I/opt/flight-direct/embedded/include -O2",
    # "OMNIBUS_INSTALL_DIR"=>"/opt/flight-direct"}
    #
    env = with_standard_compiler_flags
    configure env: env

    make "-j #{workers}", env: env
    make "-j #{workers} install", env: env
  end
end
