set +e
# Do not source any files if already sourced
if [[ -z "${FL_SOURCED}" ]]; then
  export FL_SOURCED=true

  # Sets up the `FlightDirect` environment
  export FL_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  export cw_ROOT=$FL_ROOT
  _cw_root() { echo "$cw_ROOT"; }
  export -f _cw_root

  # source the distribution specific runtime environment
  source $FL_ROOT/etc/dist-runtime.sh

  # Helper function for sourcing `profile.d` scripts
  _fl_source_profile_d() {
    local path="$1"
    if [ -d $path/etc/profile.d ]; then
      for i in $path/etc/profile.d/*.sh ; do
        if [ -r "$i" ]; then
          if [ "${-#*i}" != "\$-" ]; then
            . "$i"
          else
            . "$i" >/dev/null 2>&1
          fi
          # Ensure no flight profile leave errors on
          set +e
        fi
      done
      unset i
    fi
  }

  # Runs the other files in profile.d
  _fl_source_profile_d $FL_ROOT

  # Unsets the helper function
  unset -f _fl_source_profile_d
fi
