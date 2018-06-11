#
# This file is copied into the project when omnibus building in development mode
# It is located at the root directory to reduce the risk it is accidentally being
# built into a production release.
#

#
# This file is copied into #{install_dir}/etc/profile.d
# Deleting this file will switch development mode off (mostly?) in all future terminals
#

export FLIGHT_DIRECT_DEVELOPMENT_MODE='true'

