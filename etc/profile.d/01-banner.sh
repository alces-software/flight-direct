#/bin/bash
# Runs the moose-bird in a sub-shell. The animation can exit early which crashes the
# current shell. Instead it is ran in a sub-shell which prevents its failure from affecting
# the rest of the setup
_fl_run_moosebird() {
  local version="Flight Direct $(flight version)"
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
if [[ "$_fl_role" == login ]]; then
  _fl_long_banner
else
  cat <<EOF
[38;5;68m[40m -[ [1;38;5;249malces [1;38;5;15mflight $(flight version)[38;5;68m ]- [0m
EOF
fi

unset _fl_role
unset _fl_long_banner
unset _fl_run_moosebird
unset _fl_print_motd
