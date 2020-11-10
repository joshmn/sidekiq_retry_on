module Sidekiq
  module RetryOn
    module AttemptRetry
      def attempt_retry(worker, msg, queue, exception)
        if block = worker.class&._sidekiq_retry_on_errors_block
          begin
            result = block.call(exception, worker)
          rescue => e
            raise e
          end
          unless result
            return retries_exhausted(worker, msg, exception)
          end
        end

        if retry_on_errors = worker.class&._sidekiq_retry_on_errors
          unless retry_on_errors.include?(exception.class)
            return retries_exhausted(worker, msg, exception)
          end
        end
        super
      end
    end
  end
end
