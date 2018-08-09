# Exit if something exists with a non-zero status
set -e

# Setup the environment
root=$FL_ROOT
export PATH=$root/embedded/bin/:$PATH
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH
export TERMINFO=$root/embedded/lib/terminfo
export GEM_HOME=$root/vendor/share
export GEM_PATH=$GEM_HOME
export SSL_CERT_FILE=$root/embedded/ssl/certs/cacert.pem

# Source the distribution specific runtime environment
source $root/etc/dist-runtime.sh

# Exports the flight direct user config
flight_conf="$FL_ROOT"/var/flight.conf
if [ -f "$flight_conf" ]; then
  set -a
  source "$flight_conf"
  set +a
fi
unset flight_conf

# Sets up clusterware
export cw_BINNAME="alces"
export cw_CMDDIR="$cw_ROOT/libexec/actions"
source $cw_ROOT/lib/clusterware.kernel.sh
if [ -t 2 ]; then
  export cw_COLOUR=${cw_COLOUR:-1}
else
  export cw_COLOUR=${cw_COLOUR:-0}
fi
if [[ ":$cw_FLAGS:" =~ :nocolour: || "$TERM" == "linux" ]]; then
  export cw_COLOUR=0
fi
export cw_SHELL=bash

extract_info() {
    info=$(awk -f <(cat <<\EOF
  {
    if (substr($0,0,1) != ":") {
      next
    }
    split($0, a, ": ")
    gsub(/[[:space:]]*/, "", a[2])
    if (a[3]) {
      print "cmd_" a[2] "='" a[3] "'"
    }
    if (a[2]=="'") {
      if (started) {
        exit
      } else {
        started=1
      }
    }
  }
EOF
    ) $1)
    unset cmd_NAME cmd_SYNOPSIS cmd_VERSION cmd_HELP
    if [ "$info" ]; then
        eval "$info"
    fi
}
export -f extract_info

display_help() {
    extract_info $1
    # Render a help template here
    cat <<EOF
  NAME:

    $cw_BINNAME $cmd_NAME

  DESCRIPTION:

    $cmd_SYNOPSIS.

EOF
    #printf "    %-20s %s" "command" "XXX Command synopsis."
    echo ""
}
export -f display_help

# Adds support for running the legacy gridware package
kernel_load() { source "${cw_ROOT}/lib/clusterware.kernel.sh"; }
cw_RUBY_EXEC() { exec ruby $0 "$@"; }

# TODO: Make these 'zsh' compatible
export -f kernel_load
export -f cw_RUBY_EXEC

# Do not error anymore, useful if the file is sourced during development
set +e

