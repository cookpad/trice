# Trice
[![Build Status](https://travis-ci.org/cookpad/trice.svg?branch=master)](https://travis-ci.org/cookpad/trice)

Provides **reference time** concept to application. Use it instead of ad-hoc `Time.now`.

### Setting consistent reference time

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trice'
```

And then execute:

```
$ bundle
```

## Usage

### With Rails controller

This gem aims to serve consistency of time handling using reference time to Rails application.
The layer which should set reference time is controller layer, because reference time is one of external input.

Include `Trice::ControllerMethods` to your controller

```ruby
class ApplicationController < AC::Base
  include Trice::ControllerMethods
end
```

Then your controller and view gets an accessor method to access consistent time object.

- `requested_at`: returns timestamp of action invoked (or stubbed timestamp, see below).

### Include helper module outside of controller

Include `Trice::ReferenceTime` add `#reference_time` method to lookup current reference time.

Use it in Rails model.

```ruby
class MyWork
  include Trice::ReferenceTime

  def do!(at: nil)
    self.done_at = at || reference_time
  end
end
```

### Setting consistent reference time

Set reference time with `Trice.reference_time = _time_` or `Trice.with_reference_time(_time_, &block)`.
Accessible by `Trice.reference_time`..

```ruby
p Time.now
=> 2016-02-01 11:25:37 +0900

Trice.with_reference_time = Time.iso8601('2016-02-01T09:00:00Z')
p Trice.reference_time
# => 2016-02-01 09:00:00 UTC

Trice.with_reference_time(Time.iso8601('2016-02-01T10:00:00Z')) do
  p Trice.reference_time
  # => 2016-02-01 10:00:00 UTC
end

Trice.with_reference_time = nil
p Trice.reference_time
# => raise Trice::NoReferenceTime
```

The time is stored in thread local variable.

## Time Stubbing

Trice allows you to stub reference time to run travelled time-testing and / or previewing your app in future time.

Set `_requested_at=<timish>` query parameter like below
```
$ curl https://example.com/campaigns/12345?_requested_at=201602151300
```

Or can set HTTP header, useful for tests.
```
X-REQUESTED-AT: 2016-02-15T13:00:00+09:00
```

Value format, which specified both query parameter and header, should be `Time.parse` parasable.

#### Enable/Disable stubbing

Toggle requested at stubbing in `config/initializers`. The default is below, enabled unless `Rails.env.production?`.

```ruby
Trice.support_requested_at_stubbing = !Rails.env.production?
```

Setting callable object let you choice enable/disable dynamically by seeing request.

```ruby
our_office_network = IPAddr.new('203.0.113.0/24')

Trice.support_requested_at_stubbing = ->(controller) {
  next true unless Rails.env.production?

  our_office_network.include?(controller.request.remote_ip)
}
```

## Test helpers

There is a test helper method for feature spec.

```ruby
RSpec.configure do |config|
  config.extend Trice::SpecHelper
end
```

I recommend to pass reference time to a model by method and/or constructor argument because reference time is an external input, should be handled controller layer.
But sometimes it is required  from deep inside of model logics and tests for them.

Model unit spec has `with_reference_time` and `set_now_to_reference_time` declaration method to set `Trice.reference_time` in an example.

```ruby
describe MyModel do
  let(:reference_time) { Time.zone.parse('2016/02/03 12:00') }
  context  do
    set_reference_time { reference_time }

    let(:model) { MyModel.find_by_something(key) }

    specify do
      # can accessible `reference_time` in MyModel#do_something
      expect { model.do_something }.not_to raise(Trice::NoReferenceTime)
    end
  end
end
```

Feature specs (or other Capybara based E2E tests) also has helper method using stubbing mechanism. `stub_requested_at <timish>` set `X-Trice-Requested-At` automatically.

```ruby
context 'on ひな祭り day' do
  stub_requested_at Time.zone.parse('2016-03-03 10:00')

  scenario 'See Hinamatsuri special banner at 3/3 request' do
    visit root_path
    within '#custom-header' do
      expect(page).to contain 'ひな祭り'
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cookpad/trice.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
