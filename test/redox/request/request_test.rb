require 'test_helper'

class RequestTest < Minitest::Test
  describe 'Request' do
    let(:meta) { Redox::Models::Meta.new }

    describe '#build_body' do
      it 'has a meta' do
        result = Redox::Request.build_body({}, meta)

        assert(result.include?('Meta'))
      end

      it 'has a high level key' do
        result = Redox::Request.build_body({Z: 'hi'}, meta)

        assert(result.include?(:Z))
      end

      it 'merges with a default meta' do
        meta = Redox::Models::Meta.new(EventType: 'bob', Test: false)
        result = Redox::Request.build_body({}, meta)

        assert_equal('bob', result['Meta']['EventType'])
        assert_equal(false, result['Meta']['Test'])
        assert_equal(false, result['Meta']['EventDateTime'].nil?)
      end

      it 'fails nil meta' do
        assert_raises { Redox::Request.build_body({}, nil) }
      end
    end
  end
end
