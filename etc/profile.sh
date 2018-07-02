# Sets up the `FlightDirect` environment
export FLIGHT_DIRECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Runs the other files in profile.d
if [ -d "$FLIGHT_DIRECT_ROOT"/etc/profile.d ]; then
  for i in "$FLIGHT_DIRECT_ROOT"/etc/profile.d/*.sh ; do
    if [ -r "$i" ]; then
      if [ "${-#*i}" != "\$-" ]; then
        . "$i"
      else
        . "$i" >/dev/null 2>&1
      fi
    fi
  done
  unset i
fi
