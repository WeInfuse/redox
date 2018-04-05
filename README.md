# RedoxEngine
Ruby API wrapper for [RedoxEngine](https://www.redoxengine.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redox-engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redox-engine

## Usage

In an initializer file:
```ruby
RedoxEngine.configure do |redox|
  redox.api_key = #{Your API Key}
  redox.secret = #{Your secret}
end
```

```ruby
source = {
  Name => Your Source Name,
  ID => <REDOX_SRC_ID>
}

destinations = {
  PatientAdmin => {
    Name => Destination Name,
    ID => <REDOX_DEST_ID>
  },
  ClinicalSummary => {
    Name => Destination Name,
    ID => <REDOX_DEST_ID>
  },
  ...
}

redox = RedoxEngine::Client.new(
  source: source,
  destinations: destinations,
  test: true
)

redox.add_patient(
  Identifiers: [...],
  Demographics: {
    FirstName: 'Joe'
    ...
  }
)
```

Initializing with a persisted access token (check if it's expired, client will load naively)
```ruby
c = RedoxEngine::Client.new(
  source: source,
  destinations: destinations,
  test: true,
  token: <Existing access token>
)
```

Initializing with a persisted refresh token (client will get a new access token)
```ruby
c = RedoxEngine::Client.new(
  source: source,
  destinations: destinations,
  test: true,
  refresh_token: <Existing refresh token>
)
c.access_token # => returns new token
```

## Testing

To run the test suite, save the following in redox_keys.yml in the test/directory (already in the .gitignore for your convenience):

```yaml
api_key: <Your RedoxEngine API Key>
secret: <Your RedoxEngine API Secret>

source_data:
  Name: <RedoxEngine Source Name>
  ID: <RedoxEngine Source ID>

destinations_data:
  ClinicalSummary: 
    Name: <Destination Name>
    ID: <Destination ID>
  PatientAdmin:
    Name: <Destination Name>
    ID: <Destination ID>
  Scheduling:
    Name: <Destination Name>
    ID: <Destination ID>
  PatientSearch:
    Name: <Destination Name>
    ID: <Destination ID>

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdeona/redox.
