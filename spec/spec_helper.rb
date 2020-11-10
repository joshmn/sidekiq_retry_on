require "bundler/setup"
require "sidekiq/retry_on"
require 'sidekiq/worker'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
Sidekiq.logger.level = Logger::ERROR

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
