# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2018.3 (2.1.3)] - 2018-10-23
### Fixed
- Update references to `alces` within the help pages to `flight`

## [2018.3 (2.1.2)] - 2018-10-18
### Fixed
- Revert the user facing version to `2018.3`. The user version will no
  longer be bumped with every release

## [2018.4.pre (2.1.1)] - 2018-10-17
### Fixed
- Remove the runtime dependency on Bundler. This allows loki forge-packages
  to use a separate Gemfile

## [2018.3 (2.1.0)] - 2018-10-08
### Added
- Allow for optional configuration script before installing forge packages.

## [2018.2 (2.0.2)] - 2018-10-08
### Changed
- Add a date based user version number

### Removed
- The version number has been removed from the short banner displayed on
  compute nodes

## [2.0.1] - 2018-10-01
### Fixed
- Update the `forge-cli` so it can find the upstream anvil server by default
