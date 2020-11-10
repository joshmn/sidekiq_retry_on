module Sidekiq
  module RetryOn
    module Worker
      module ClassMethods
        def _sidekiq_retry_on_errors
          @_sidekiq_retry_on_errors
        end

        def retry_on(*errors)
          @_sidekiq_retry_on_errors = Array.new(errors)
        end

        def _sidekiq_retry_on_errors_block
          @_sidekiq_retry_on_errors_block
        end

        def retry_on_errors(&block)
          @_sidekiq_retry_on_errors_block = block
        end
      end

      def self.included(klass)
        klass.extend(ClassMethods)
        klass.attr_accessor :retry_count
      end

      def retry_count
        @retry_count || 0
      end
    end
  end
end
