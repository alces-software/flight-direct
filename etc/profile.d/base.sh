################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

flight() {
  local target
  target="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. && pwd)"
  ( cd $target && \
    PATH="$target/embedded/bin/:$PATH" && \
    bin/flight "$@"
  )
}
alias flight-direct=flight

