# Sidekiq::RetryOn

Conditional retries for Sidekiq.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq_retry_on'
```

And then execute:

    $ bundle install

## Usage

There are two ways of invoking conditional retries.

### Using an array of errors

```ruby 
class MyWorker
  include Sidekiq::Worker
  include Sidekiq::RetryOn::Worker

  sidekiq_options retry: 5 
  retry_on Net::HTTPError, HTTParty::Error

  def perform
    # ... 
  end 
end
```

### Using a block


```ruby 
class MyWorker
  include Sidekiq::Worker
  include Sidekiq::RetryOn::Worker
  
  sidekiq_options retry: 5 
  retry_if do |exception, worker|
    if [Net::HTTPError, HTTParty::Error].include?(exception.class)
      if exception.class.is_a?(HTTParty::Error) && worker.retry_count == 3 
        false
      else
        true 
      end
    else
      false 
    end
  end 

  def perform
    # ... 
  end 
end
```

## Development

Good luck.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshmn/sidekiq_retry_on. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joshmn/sidekiq_retry_on/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
