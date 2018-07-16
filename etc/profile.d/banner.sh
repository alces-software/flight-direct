#/bin/bash
# Runs the moose-bird in a sub-shell. The animation can exit early which crashes the
# current shell. Instead it is ran in a sub-shell which prevents its failure from affecting
# the rest of the setup

_run_flight_banner() {
  local version="FlightDirect $(flight version)"
  local key='PRETTY_NAME='
  local dist=$(cat /etc/os-release | grep $key | tr -d $key | tr -d '"')
  (. "$FL_ROOT"/scripts/moosebird.sh 'TODO_CLUSTERNAME' "$version" "$dist")
}
_run_flight_banner
unset _run_flight_banner

