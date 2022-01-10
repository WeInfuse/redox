require 'test_helper'

class RedoxExceptionTest < Minitest::Test
  describe 'redox exceptions' do
    let(:redox_exception) { Redox::RedoxException.from_response(sample_response) }
    let(:sample_response) { OpenStruct.new(code: 500, parsed_response: load_sample('error.response.json', parse: true)) }

    describe 'redox error response' do
      it 'handles the arrays' do
        assert_match(/HTTP code: 500/, redox_exception.to_s)
        assert_match(/MSG: No subscriptions/, redox_exception.to_s)
      end
    end

    describe 'no error response' do
      let(:sample_response) { OpenStruct.new(code: 422, parsed_response: 'blahblahblah') }

      it 'handles the arrays' do
        assert_match(/HTTP code: 422/, redox_exception.to_s)
        assert_match(/MSG: blahblahblah/, redox_exception.to_s)
      end
    end
  end
end
