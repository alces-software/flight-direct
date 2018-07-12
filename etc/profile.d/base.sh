################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

# The delimiter is defined with interpolation so it does not get subbed
# when the env is being parsed

flight() {
  _flight() {
    ( set -e
      unset FLIGHT_DIRECT_ENV_BACKUP
      delim=":$(echo 'FD_DELIM'):"
      export FLIGHT_DIRECT_ENV_BACKUP="$(env -0 | sed "s/\x0/$delim/g")"
      source "$FLIGHT_DIRECT_ROOT"/etc/runtime.sh
      cd "$FLIGHT_DIRECT_ROOT"
      bin/flight "$@"
    )
  }

  # The module command needs to be `eval'd` within the current shell
  # Thus it polls `flight modulecmd` for the string and then runs it
  # It only matches shorthand between `mo-module`
  if [[ $1 == 'mo'* && 'module' == "$1"* ]]; then
    shift 1
    if module_env=$(_flight 'modulecmd' "$@"); then
      eval $module_env
    else
      echo 'An error has occurred running module' >&2
      echo "$module_env" >&2
    fi
  else
    _flight "$@"
  fi
  unset _flight
}
export -f flight

# Exports the aliases so they are available in subshells
declare -a aliases=('flight-direct' 'fl' 'alces' 'al')
for a in "${aliases[@]}"; do
  eval "$a() { flight \"\$@\"; }"
  export -f "$a"
  unset a
done
unset aliases

