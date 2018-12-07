# FlightDirect
## Environment Information

By sourcing `profile.sh` the `FL_ROOT` and `flight` function are
set in your environment. This tells `flight` where to look for its source
code. The moosebird banner and `MOT` are also triggered on the login shell.
NOTE: `forge` packages may make additional changes to the environment, 
please see the packages documentation for details.

`flight direct` currently wraps a slimmed down version of the `clusterware`
utility which runs the legacy code. Clusterware is always installed to
`$FL_ROOT/opt/clusterware`. This directory is set as the
`cw_ROOT` which tells clusterware kernel where to look for its functions.

The `flight direct` core utility (inc clusterware) has been designed to be
self contained. There are no runtime dependencies required (beyond a blank
Centos7 image). When the `flight` bash function is invoked, the
`etc/runtime.sh` file is sourced. This sets up the `PATH`, `LD_LIBRARY_PATH`,
etc to point to the `FL_ROOT` directory. Refer to `runtime.sh` 
for a full list of changes.

The runtime environment is sourced with a sub-shell and thus any changes
will not persist after the command has executed. However it does mean the
flight-direct version of libraries will be used instead of the system ones.

### Configuring Forge

Whilst `forge` is automatically installed with `flight direct`, it is
maintained in a separate repo. Please consult `forge-cli` itself for
configuration details:
https://github.com/alces-software/forge-cli

## Build From Source
### Build Requirements
You must have a sane Ruby 2.0.0+ environment with Bundler installed. Ensure
the development gems are installed.

The default install location is into `/opt/flight-direct`. If you do not
have write permission to opt, the install directory can be changed by 
setting `FL_ROOT` environment variable.

```shell
$ cd <source-code-location>
$ bundle install --without defaults --with development
```
### Build

You create a platform-specific package using the `build project` command:

```shell
$ omnibus build flight-direct
```

To install in development mode, run:

```shell
$ omnibus build flight-direct-dev
```

#### NOTE: Building as a non-root user

By default, `flight-direct` is built into `/opt/flight-direct`. If you do
not have write permissions within `/opt`, you will need to change the
`FL_ROOT` environment variable to be within your `$HOME`
directory.

#### NOTE: RPM Build Error

Omnibus was originally designed to create `rpm's`, however tarballs are the
preferred publishing mechanism. As such the tarball is created directly
from the root directory.

However `Omnibus` continues to try and create the rpm, which will result in
an error if `rpm-build` hasn't been installed. This error means that the
build was successful and can be safely ignored.

Alternatively installing `rpm-build` will suppress the error, however the
`rpm` will be built.

### Releasing a new version

New version of `flight-direct` can be released on AWS using the staff
credentials. All that is required is firing up the release template (below)
on cloud formation. This will start a build machine and saves the tarball in
S3 automatically.
`templates/cloud-release-template.yaml`

NOTE: The release `Version` needs to be given as a parameter to the template.

### Clean

You can clean up all temporary files generated during the build process with
the `clean` command:

```shell
$ bin/omnibus clean flight-direct
```

Adding the `--purge` purge option removes __ALL__ files generated during the
build including the project install directory (`/opt/flight-direct`) and
the package cache directory (`/var/cache/omnibus/pkg`):

```shell
$ bin/omnibus clean flight-direct --purge
```

### Version Manifest

Git-based software definitions may specify branches as their
default_version. In this case, the exact git revision to use will be
determined at build-time unless a project override (see below) or
external version manifest is used.  To generate a version manifest use
the `omnibus manifest` command:

```
omnibus manifest PROJECT -l warn
```

This will output a JSON-formatted manifest containing the resolved
version of every software definition.

