################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

# The delimiter is defined with interpolation so it does not get subbed
# when the env is being parsed
flight() {
  ( set -e
    unset FLIGHT_DIRECT_ENV_BACKUP
    delim=":$(echo 'FD_DELIM'):"
    export FLIGHT_DIRECT_ENV_BACKUP="$(env -0 | sed "s/\x0/$delim/g")"
    source "$FLIGHT_DIRECT_ROOT"/etc/runtime.sh
    cd "$FLIGHT_DIRECT_ROOT"
    bin/flight "$@"
  )
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

