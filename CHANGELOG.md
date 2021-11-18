# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.7.2] - 2021-11-18
### Added
- Component Model
- Notes#Components

## [1.7.1] - 2021-10-07
### Added
- Visit#ReferringProvider and helpers for ID, IDType, FirstName, LastName

## [1.7] - 2021-06-08
### Added
- Notes model

## [1.6.1] - 2021-03-12
### Added
- Media model file helper to base64 files under 200KB
- Media model available= sets to valid Redox values with true/false
- Medai model provider entry

## [1.6.0] - 2021-02-04
### Added
- Media model
- MediaUpdate Model
- Media#create
- Visit#CancelReason
- Visit#DischargeDateTime

## [1.5.2] - 2021-01-08
### Added
- Visit#Type
- Visit#Status
- Visit#Reason
- Visit#Equipment

## [1.5.1] - 2020-12-22
### Added
- Contacts model
- Patient#contacts

### Changed
- typo of martialstatus is now maritalstatus for Demographics model

## [1.5.0] - 2020-12-15
### Added
- Scheduling model
- Scheduling#create
- Scheduling#cancel
- Scheduling#reschedule
- Scheduling#modification

## [1.4.0] - 2020-10-13
### Added
- AbstractModel that does not add top level key
- OrderingProvider that is the base for PCP
- Provider model
- Provider#query
- Created new method that can add helpers dynamically from response

## [1.3.1] - 2020-10-02
### Added
- Transaction#as\_json
- Visit#as\_json

## [1.3.0] - 2020-09-17
### Added
- Transaction model
- Financial#create

## [1.2.0] - 2020-07-30
### Added
- Visit model
- Model#insurances helper for Patient.Insurances || Visit.Insurances

## [1.1.1] - 2020-06-15
### Changed
- Bugfix with patient param in update

## [1.1.0] - 2020-06-15
### Changed
- Moving to Requst classes instead of mixing in logic to models (kept backwards compatibility)
- Added potential matches to responses and implemented for patient search

### Added
- PotentialMatches class

## [1.0.2] - 2019-06-04
### Changed
- Added Extensions to all Redox models
- Fixed warnings in gemspec
- Fixed author emails in gemspec
- Removed packaging of bin and files starting with '.'
- Added helper file to translate Redox JSON to Hashie model.

### Removed
- Unused response model.

## [1.0.1] - 2019-05-02
### Changed
- Check for high-level key as symbol

## [1.0.0] - 2019-05-01
### Changed
- How it works

### Added
- Connection, RedoxClient, Authorization
- Global configuration block
- Gems httparty, hashie

### Removed
- Identifiers, Demographics

## [0.1.6] - 2019-04-22
### Added
- Meta model
- Response and Authentication classes

### Changed
- Created a single request method
- Allow caller to override all Meta
- Made calls consistent in return and call signature

## [0.1.5] - 2019-04-09
### Added
- Patient, Demographics, Identities models

## [0.1.4] - 2019-04-02
### Added
- Patient search

### Changed
- Raise on auth failure
- Tweaks to console setup

## [0.1.3] - 2018-10-03
### Added
- Code of Conduct
- CircleCI status badge
- PatientUpdate EventType
- Ability to set FacilityCode

### Changed
- Update gemspec to allow pushes to rubygems.org

### Removed
- rubocop

## [0.1.2] - 2018-03-08
### Added
- CircleCI config
- .editorconfig
- Added rubocop as dev dependency

### Changed
- Corrected author email
- Tweaks to pass rubocop

## [0.1.1] - 2017-10-12
### Removed
- Redundant .gem file
- Fix WeInfuse capitalization

## 0.1.0 - 2017-10-12
### Added
- Initial Release

[1.7.2]: https://github.com/WeInfuse/redox/compare/v1.7.1...v1.7.2
[1.7.1]: https://github.com/WeInfuse/redox/compare/v1.7...v1.7.1
[1.7]: https://github.com/WeInfuse/redox/compare/v1.6.1...v1.7
[1.6.1]: https://github.com/WeInfuse/redox/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/WeInfuse/redox/compare/v1.5.2...v1.6.0
[1.5.2]: https://github.com/WeInfuse/redox/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/WeInfuse/redox/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/WeInfuse/redox/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/WeInfuse/redox/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/WeInfuse/redox/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/WeInfuse/redox/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/WeInfuse/redox/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/WeInfuse/redox/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/WeInfuse/redox/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/WeInfuse/redox/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/WeInfuse/redox/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/WeInfuse/redox/compare/v0.1.6...v1.0.0
[0.1.6]: https://github.com/WeInfuse/redox/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/WeInfuse/redox/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/WeInfuse/redox/compare/0.1.3...v0.1.4
[0.1.3]: https://github.com/WeInfuse/redox/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/WeInfuse/redox/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/WeInfuse/redox/compare/0.1.0...0.1.1
