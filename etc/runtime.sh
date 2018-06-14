root=$FLIGHT_DIRECT_ROOT
export PATH=$root/embedded/bin/:$PATH && \
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH && \
export GEM_HOME=$root/embedded/lib/ruby/gems && \
export GEM_PATH=$GEM_HOME:$GEM_PATH && \
export BUNDLE_PATH=$root/vendor/cache && \
export cw_ROOT=$root && \
if [ -z "$cw_FORGE_API_URL" ]; then
  export cw_FORGE_API_URL='https://forge-api.alces-flight.com/v1'
fi
