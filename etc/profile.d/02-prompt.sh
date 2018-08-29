#!/bin/bash

# TODO: The code below is duplicated in 01-banner.sh. Consider refactor

# This allows profile scripts to poll for config values
# without booting up ruby. This about 50x faster than running
# `flight config get`
# NOTE: THIS IS A DUMB TOOL! The input must be in capitals
_fl_helper_config_get() {
  echo $(
    key="FL_CONFIG_$1"
    set -a +e
    source "$FL_ROOT"/var/flight.conf 2>/dev/null
    echo "${!key}"
  )
}

if [ "$PS1" ]; then
  name=$(_fl_helper_config_get CLUSTERNAME)
  role=$(_fl_helper_config_get ROLE)

  if [ "$name" ]; then
    if [ "$role" == 'master' ]; then
      PS1="[\u@\h\[\e[38;5;68m\]($name)\[\e[0m\] \W]\\$ "
    else
      PS1="[\u@\h\[\e[48;5;17;38;5;33m\]($name)\[\e[0m\] \W]\\$ "
    fi
  else
    PS1="[\u@\h\[\e[1;31m\](unconfigured)\[\e[0m\] \W]\\$ "
  fi
  unset name role
fi

unset -f _fl_helper_config_get
