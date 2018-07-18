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

  # This allows profile scripts to poll for config values
  # without booting up ruby. This about 50x faster than running
  # `flight config get`
  # NOTE: THIS IS A DUMB TOOL! The input must be in capitals
  _fl_helper_config_get() {
    echo $(
      key="FL_CONFIG_$1"
      set -a +e
      source "$FL_ROOT"/var/flight.conf 2>/dev/null
      value=${!key}
      if [[ -z "$value" ]]; then
        cat <<WARN >&2
WARNING: '$key' has not been set
See "flight config set" for further details
WARN
      fi
      echo "$value"
    )
  }

  # Runs the other files in profile.d
  _fl_source_profile_d $FL_ROOT

  # Unsets the helper function
  unset -f _fl_source_profile_d
  unset -f _fl_helper_config_get
fi
