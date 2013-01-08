# Sidekiq::Isochronal

Sidekiq::Isochronal gives you a sophisticated scheduling facility for Sidekiq jobs. Or, it will do.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'sidekiq-isochronal', github: 'musicglue/sidekiq-isochronal'
```

## Usage

Once it is in your ```Gemfile``` then you have access to a new ```.periodicly``` method in your workers.

To use this (and please be aware, this is a WIP gem - this API will change, I don't suggest you use it!), you can do the following:

```ruby
class Worker
  include Sidekiq::Worker
  periodicly every: 5.seconds
  def perform
    puts "Hello!"
  end
end
```

Then it'll batter on, doing this over and again every 5 seconds.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
