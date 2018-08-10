[![CircleCI](https://circleci.com/gh/WeInfuse/redox.svg?style=svg)](https://circleci.com/gh/WeInfuse/redox)

# Redox
Ruby API wrapper for [Redox Engine](https://www.redoxengine.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redox

## Usage

```ruby
source = {
  Name: 'Redox Dev Tools',
  ID: ENV['REDOX_SRC_ID']
}

destinations = [
  {
    Name: 'Redox EMR',
    ID: ENV['REDOX_DEST_ID']
  }
]

redox = Redox::Redox.new(
  api_key: ENV['REDOX_KEY'],
  secret: ENV['REDOX_SECRET'],
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WeInfuse/redox.
