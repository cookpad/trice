# Trice

Provides `performing_at` timestamp. Use it instead of ad-hoc `Time.now`.

## Usage

Include `Trice::ControllerMethods` to your controller.

```ruby
class ApplicationController < AC::Base
  include Trice::ControllerMethods
end
```

Then your controller gets 2 time accessor. (also available in view)

- `performing_at`: returns timestamp of action invoked performing or stubbed timestamp.
- `raw_performing_at`: returns timestamp of action invoked performing, not stubbed timestamp.

Use `performing_at` instead of ad-hoc `Time.now` in controller and view logic.

### Time Stubbing

Trice allows you to stub time to run travelled time-testing and / or previewing your app in future time.
テストなどのため、`performing_at`の時刻をスタブすることができます。

クエリパラメータに`_performiing_at=`というキーを含めると、`performing_at`をスタブできます。
これは主に、時限機能をプレビューするのに使う想定です。
```
$ curl https://example.com/campaigns/12345?_performiing_at=20160215130
```

テストなどからアクセスする場合、リクエストヘッダでもスタブできます。
```
TricePrformingAt: 2016-02-15T13:00:00+09:00
```

それぞれ、`Time.parse`で指定できる文字を設定してください。

#### Test helpers

feature specでのヘルパーメソッドもあります。
```
scenario 'See Hinamatsuri special banner at 3/3 request' do
  stub_performing_at Time.zone.parse('2016-03-03 10:00')

  visit root_path
  within '#custom-header' do
    expect(page).to contain 'ひな祭り'
  end
end
```

#### Enable/Disable stubbing

`config/initializers`などで、時刻をスタブするかどうかを切り替えられます。デフォルトでは`Rails.env.production?`以外で有効です。
```
Trice.support_performing_at_stubbing = Rails.env.production?
```

callableを指定するとリクエストの中身を見てオンオフを切り替えられます。
```
our_office_network = IPAddr.new('203.0.113.0/24')

Trice.support_performing_at_stubbing = ->(req) {
  next true unless Rails.env.production?

  our_office_network.include?(req.remote_ip)
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/trice. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

