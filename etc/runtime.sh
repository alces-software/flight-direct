root=$FLIGHT_DIRECT_ROOT
vendor_flight=$root/vendor/flight
export PATH=$root/embedded/bin/:$vendor_flight/bin:$PATH && \
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH && \
export TERMINFO=$root/embedded/lib/terminfo && \
export GEM_HOME=$root/vendor/share && \
export GEM_PATH=$GEM_HOME:$vendor_flight && \
export BUNDLE_PATH=$GEM_HOME && \
source $root/opt/clusterware/lib/clusterware.kernel.sh && \
if [ -z "$cw_FORGE_API_URL" ]; then
  export cw_FORGE_API_URL='https://forge-api.alces-flight.com/v1'
fi
