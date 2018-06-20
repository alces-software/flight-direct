root=$FLIGHT_DIRECT_ROOT
export PATH=$root/embedded/bin/:$PATH && \
export LD_LIBRARY_PATH=$root/embedded/lib:$LD_LIBRARY_PATH && \
export TERMINFO=$root/embedded/lib/terminfo && \
export GEM_HOME=$root/vendor/share && \
export GEM_PATH=$GEM_HOME:$GEM_PATH && \
export BUNDLE_PATH=$GEM_HOME && \
export cw_ROOT=$root && \
export cw_LIBPATH=$root/opt/clusterware/functions && \
source $root/opt/clusterware/clusterware.kernel.sh && \
if [ -z "$cw_FORGE_API_URL" ]; then
  export cw_FORGE_API_URL='https://forge-api.alces-flight.com/v1'
fi
