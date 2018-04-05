# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2018-04-04
- Refactor + linting
- Change to README

## [1.0.0] - 2018-04-04 
- (Renamed 0.1.3)
- Change RedoxEngine::RedoxEngine to RedoxEngine::Client
- Refactor Module to accept configuration
- Refactor Client to pass Rubocop linting
- Refactor Client to accept stored token/refresh token
- Refactor/add tests
- Add methods:
  - client.update_patient
  - client.get_booked_slots
  - client.search_patient
  - client.get_summary_for_patient
- Add classes:
  - Patient
  - Visit
- Bump Ruby version to 2.4.1

# [0.1.2] - 2018-03-08
### Added
- CircleCI config
- .editorconfig
- Added rubocop as dev dependency

### Changed
- Corrected author email
- Tweaks to pass rubocop

# [0.1.1] - 2017-10-12
### Removed
- Redundant .gem file
- Fix WeInfuse capitalization

## 0.1.0 - 2017-10-12
### Added
- Initial Release

[Unreleased]: https://github.com/WeInfuse/redox/compare/0.1.2...HEAD
[0.1.2]: https://github.com/WeInfuse/redox/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/WeInfuse/redox/compare/0.1.0...0.1.1
