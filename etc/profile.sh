# Do not source any files if already sourced
if [[ -z "${FLIGHT_DIRECT_SOURCED}" ]]; then
  export FLIGHT_DIRECT_SOURCED=true

  # Sets up the `FlightDirect` environment
  export FLIGHT_DIRECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  export cw_ROOT=$FLIGHT_DIRECT_ROOT/opt/clusterware
  _cw_root() { echo "$cw_ROOT"; }
  export -f _cw_root

  # source the distribution specific runtime environment
  source $FLIGHT_DIRECT_ROOT/etc/dist-runtime.sh

  # Helper function for sourcing `profile.d` scripts
  _fd_source_profile_d() {
    local path="$1"
    if [ -d $path/etc/profile.d ]; then
      for i in $path/etc/profile.d/*.sh ; do
        if [ -r "$i" ]; then
          if [ "${-#*i}" != "\$-" ]; then
            . "$i"
          else
            . "$i" >/dev/null 2>&1
          fi
        fi
      done
      unset i
    fi
  }

  # Runs the other files in profile.d
  _fd_source_profile_d $FLIGHT_DIRECT_ROOT
  _fd_source_profile_d $cw_ROOT

  # Unsets the helper function
  unset -f _fd_source_profile_d

  # Ensure that errors don't crash the shell
  set +e
fi
