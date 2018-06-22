export cw_ROOT=$FLIGHT_DIRECT_ROOT/opt/clusterware
export cw_LIBPATH=$cw_ROOT/opt/clusterware/lib/functions

# Runs the clusterware profile scripts, this is required by the legacy
# packages
if [ -d "$cw_ROOT"/etc/profile.d ]; then
  for i in "$cw_ROOT"/etc/profile.d/*.sh ; do
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

