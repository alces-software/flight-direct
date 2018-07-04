set -e
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
