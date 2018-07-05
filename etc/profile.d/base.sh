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
alias flight-direct=flight
alias fl=flight
alias alces=flight
alias al=flight

