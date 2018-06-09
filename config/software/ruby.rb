
name "ruby"
default_version "2.5.1"
source url: "http://ftp.ruby-lang.org/pub/ruby/ruby-#{version}.tar.gz",
       md5: "23867bc8c16c55e43b14dfe0614bcfa8"

dependency "flight-direct-zlib"
# dependency "ncurses"
# dependency "openssl"

relative_path "ruby-#{version}"

build do
  command "./configure --prefix #{install_dir}/opt/ruby --with-zlib-dir=#{install_dir}/zlib"
  command "make"
  command "make install"
end

