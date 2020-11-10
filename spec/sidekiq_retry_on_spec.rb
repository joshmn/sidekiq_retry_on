require 'spec_helper'

RSpec.describe Sidekiq::RetryOn do

  class EnabledOnWorker
    include Sidekiq::Worker
    include Sidekiq::RetryOn::Worker
    retry_on NameError
  end

  class EnabledBlockWorker
    include Sidekiq::Worker
    include Sidekiq::RetryOn::Worker
    retry_on_errors do |exception, _worker|
      if exception.is_a?(NameError)
        true
      else
        false
      end
    end
  end

  def handler(options={})
    @handler ||= Sidekiq::JobRetry.new(options)
  end

  def jobstr(options={})
    Sidekiq.dump_json({ 'class' => 'EnabledWorker', 'args' => [], 'retry' => true }.merge(options))
  end

  context 'retry_on' do
    context 'with a mismatched error' do
      it 'does not enqueue' do
        rs = Sidekiq::RetrySet.new
        size_was = rs.size
        expect {
          handler.local(EnabledOnWorker.new, jobstr('retry' => 1), 'default') do
            raise ArgumentError
          end
        }.to raise_error(RuntimeError)
        expect(rs.size).to eq(size_was)
      end
    end

    context 'with a matched error' do
      it 'does enqueue' do
        rs = Sidekiq::RetrySet.new
        size_was = rs.size
        expect {
          handler.local(EnabledOnWorker.new, jobstr('retry' => 1), 'default') do
            raise NameError
          end
        }.to raise_error(RuntimeError)
        expect(rs.size).to_not eq(size_was)
      end
    end
  end

  context 'retry_on block' do
    context 'with a mismatched error' do
      it 'does not enqueue' do
        rs = Sidekiq::RetrySet.new
        size_was = rs.size
        expect {
          handler.local(EnabledBlockWorker.new, jobstr('retry' => 1), 'default') do
            raise ArgumentError
          end
        }.to raise_error(RuntimeError)
        expect(rs.size).to eq(size_was)
      end
    end

    context 'with a matched error' do
      it 'does enqueue' do
        rs = Sidekiq::RetrySet.new
        size_was = rs.size
        expect {
          handler.local(EnabledBlockWorker.new, jobstr('retry' => 1), 'default') do
            raise NameError
          end
        }.to raise_error(RuntimeError)
        expect(rs.size).to_not eq(size_was)
      end
    end
  end
end
