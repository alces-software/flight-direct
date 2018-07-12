# Exit if something exists with a non-zero status
set -e

# Setup the environment
root=$FLIGHT_DIRECT_ROOT
export PATH=$root/embedded/bin/:$PATH
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH
export TERMINFO=$root/embedded/lib/terminfo
export GEM_HOME=$root/vendor/share
export GEM_PATH=$GEM_HOME
export SSL_CERT_FILE=$root/embedded/ssl/certs/cacert.pem

# Source the distribution specific runtime environment
source $root/etc/dist-runtime.sh

# Sets up clusterware
source $cw_ROOT/lib/clusterware.kernel.sh
if [[ -t 1 && "$TERM" != linux ]]; then
    export cw_COLOUR=1
else
    export cw_COLOUR=0
fi
export cw_SHELL=bash

# Adds support for running the legacy gridware package
kernel_load() { source "${cw_ROOT}/lib/clusterware.kernel.sh"; }
cw_RUBY_EXEC() { exec ruby $0 "$@"; }

# TODO: Make these 'zsh' compatible
export -f kernel_load
export -f cw_RUBY_EXEC

# Do not error anymore, useful if the file is sourced during development
set +e

