# Exit if something exists with a non-zero status
set -e

# Setup the environment
root=$FLIGHT_DIRECT_ROOT
vendor_flight=$root/vendor/flight
export PATH=$root/embedded/bin/:$vendor_flight/bin:$PATH
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH
export TERMINFO=$root/embedded/lib/terminfo
export GEM_HOME=$root/vendor/share
export GEM_PATH=$GEM_HOME:$vendor_flight
export BUNDLE_PATH=$GEM_HOME
export SSL_CERT_FILE=$root/embedded/ssl/certs/cacert.pem
source $cw_ROOT/lib/clusterware.kernel.sh

# Adds support for running the legacy gridware package
kernel_load() { source "${cw_ROOT}/lib/clusterware.kernel.sh"; }
cw_RUBY_EXEC() { exec ruby $0 "$@"; }
export -f kernel_load
export -f cw_RUBY_EXEC

# Do not error anymore, useful if the file is sourced during development
set +e

