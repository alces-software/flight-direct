flight-direct Omnibus project
=============================
This project creates full-stack platform-specific packages for
`flight-direct`!

# Build From Source
-------------------
## Build Requirements
You must have a sane Ruby 2.0.0+ environment with Bundler installed. Ensure
the development gems are installed.

The default install location is into `/opt/flight-direct`. If you do not
have write permission to opt, the install directory can be changed by 
setting `FLIGHT_DIRECT_ROOT` environment variable.

```shell
$ cd <source-code-location>
$ bundle install --without defaults --with development
```
## Build

You create a platform-specific package using the `build project` command:

```shell
$ omnibus build flight-direct
```

To install in development mode, run:

```shell
$ omnibus build flight-direct-dev
```

### NOTE: Building as a non-root user

By default, `flight-direct` is built into `/opt/flight-direct`. If you do
not have write permissions within `/opt`, you will need to change the
`FLIGHT_DIRECT_ROOT` environment variable to be within your `$HOME`
directory.

### NOTE: RPM Build Error

Omnibus was originally designed to create `rpm's`, however tarballs are the
preferred publishing mechanism. As such the tarball is created directly
from the root directory.

However `Omnibus` continues to try and create the rpm, which will result in
an error if `rpm-build` hasn't been installed. This error means that the
build was successful and can be safely ignored.

Alternatively installing `rpm-build` will suppress the error, however the
`rpm` will be built.

## Clean

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

## Version Manifest

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

