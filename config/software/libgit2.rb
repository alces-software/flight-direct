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

name 'libgit2'
default_version "v0.27.0"

relative_path "libgit2-#{version}"
source git: 'https://github.com/libgit2/libgit2.git'

# license "Zlib"
# license_file "README"
# skip_transitive_dependency_licensing true

dependency 'git'

env = with_standard_compiler_flags(with_embedded_path)

build do
  # Creates the build directory
  cmake_build_dir = "#{project_dir}/build"
  mkdir cmake_build_dir

  # Builds and installs libgit2
  prefix = "#{install_dir}/embedded"
  command <<-CMD, env: env
    cd #{cmake_build_dir}
    cmake .. -DCMAKE_INSTALL_PREFIX=#{prefix} -DCMAKE_PREFIX_PATH=#{prefix}
    export LD_LIBRARY_PATH=#{prefix}/lib
    cmake --build . --target install
  CMD
end
