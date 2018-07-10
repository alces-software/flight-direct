################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

flight() {
  ( source "$FLIGHT_DIRECT_ROOT"/etc/runtime.sh && \
    cd "$FLIGHT_DIRECT_ROOT" && \
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

