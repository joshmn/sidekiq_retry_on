require 'sidekiq/retry_on/version'
require 'sidekiq/retry_on/retry'
require 'sidekiq/retry_on/worker'
require 'sidekiq/retry_on/attempt_retry'
require 'sidekiq/job_retry'

module Sidekiq
  class JobRetry
    prepend Sidekiq::RetryOn::AttemptRetry
  end
end
