#/bin/bash
# Runs the moose-bird in a sub-shell. The animation can exit early which crashes the
# current shell. Instead it is ran in a sub-shell which prevents its failure from affecting
# the rest of the setup

# TODO: The code below is duplicated in 02-prompt.sh. Consider refactor

# This script is ran by the `csh` banner script. Thus the base profile script
# might need to be sourced
if [ -z "$BASH_FUNC_flight" ]; then
  source $FL_ROOT/etc/profile.d/00-base.sh
fi

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

_fl_run_moosebird() {
  local version="Flight Direct $(flight version --user)"
  local dist=$(. /etc/os-release; echo $PRETTY_NAME)
  local name=$(_fl_helper_config_get CLUSTERNAME)
  name=${name:-Unconfigured}
  (. "$FL_ROOT"/scripts/moosebird.sh "$name" "$version" "$dist")
}
_fl_print_motd() {
  local i
  if [ -d "$FL_ROOT"/etc/motd.d ]; then
    # Text and scripts are globed together to ensure they are run in
    # the correct order
    for i in $(ls "$FL_ROOT"/etc/motd.d/*.{sh,txt} 2>/dev/null) ; do
      if [ -r "$i" ]; then
        # Cat text files
        if [ "${i: -4}" == '.txt' ]; then
          cat "$i" | sed '/^#/ d'

        # Runs sh files NOTE: They are cat'd to avoid permissions issues
        elif [ "${i: -3}" == '.sh' ]; then
          cat $i | bash | sed '/^#/ d'
        fi
      fi
    done
  fi
}

_fl_long_banner() {
  _fl_run_moosebird
  _fl_print_motd
}
_fl_role=$(_fl_helper_config_get ROLE)
_fl_role=${_fl_role:-login}

# Do not print the banner for non-interactive shells
if [[ -t 0 ]]; then
  if [[ "$_fl_role" == login ]]; then
    _fl_long_banner
  else
    cat <<EOF
[38;5;68m[40m -[ [1;38;5;249malces [1;38;5;15mflight [38;5;68m ]- [0m
EOF
  fi
fi

unset _fl_role
unset _fl_long_banner
unset _fl_run_moosebird
unset _fl_print_motd
unset -f _fl_helper_config_get
