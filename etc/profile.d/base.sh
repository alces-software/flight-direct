################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

flight() {
  local target
  target=$FLIGHT_DIRECT_ROOT
  ( cd "$target" && \
    PATH="$target/bin:$target/embedded/bin/:$PATH" && \
    unset GEM_PATH && unset GEM_HOME && unset BUNDLE_PATH && \
    bin/flight "$@"
  )
}
alias flight-direct=flight

