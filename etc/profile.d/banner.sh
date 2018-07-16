#/bin/bash
# Runs the moose-bird in a sub-shell. The animation can exit early which crashes the
# current shell. Instead it is ran in a sub-shell which prevents its failure from affecting
# the rest of the setup

version="FlightDirect $(flight version)"
(. "$FL_ROOT"/scripts/moosebird.sh 'TODO_CLUSTERNAME' "$version" 'TODO_DISTRO')
unset version
