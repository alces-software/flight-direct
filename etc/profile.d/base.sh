################################################################################
##
## Alces FlightDirect
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################

# The delimiter is defined with interpolation so it does not get subbed
# when the env is being parsed

_flight() {
  ( set -e
    unset FL_ENV_BACKUP
    delim=":$(echo 'FD_DELIM'):"
    export FL_ENV_BACKUP="$(env -0 | sed "s/\x0/$delim/g")"
    source "$FL_ROOT"/etc/runtime.sh
    cd "$FL_ROOT"
    bin/flight "$@"
  )
}
export -f _flight

flight() {
  # The module command needs to be `eval'd` within the current shell
  # Thus it polls `_flight module` for the string and then evals
  # It only matches shorthand between `mo-module`
  if [[ $1 == 'mo'* && 'module' == "$1"* ]]; then
    shift 1
    if [[ ! $(ps -o 'command=' -p "$$" 2>/dev/null) =~ ^- ]]; then
      # Not an interactive shell
      if [[ ! ":$cw_FLAGS:" =~ :verbose-modules: ]]; then
        export cw_MODULES_VERBOSE=0
      fi
    fi
    case $1 in
      fl*|al*|h*|-h|--help)
        if [[ ":$cw_FLAGS:" =~ :nopager: ]]; then
          _flight 'module' "$@" 0>&1 2>&1
        else
          _flight 'module' "$@" 0>&1 2>&1 | less -FRX
        fi
        ;;
      *)
        if [[ ":$cw_FLAGS:" =~ :nopager: ]]; then
          eval $(_flight 'module' "$@") 2>&1
        elif [ -n "$POSIXLY_CORRECT" ]; then
          eval $(_flight 'module' "$@") 2>&1
        elif [ "$2" == "load" -o "$2" == "add" ]; then
          eval $(_flight 'module' "$@") 2>&1
        else
          local p
          p="${_cw_ROOT}"
          eval $(_flight 'module' "$@" 2> >(less -FRX >&2)) 2>&1
        fi
        ;;
    esac
  else
    _flight "$@"
  fi
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

