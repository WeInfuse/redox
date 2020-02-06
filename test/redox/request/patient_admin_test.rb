require 'test_helper'

class PatientAdminTest < Minitest::Test
  describe 'PatientAdmin' do
    let (:meta) { Redox::Models::Meta.new }

    describe '#body' do
      describe 'creates a request' do
        it 'has a meta' do
          result = Redox::Request::PatientAdmin.build_body({}, meta)

          assert(result.include?('Meta'))
        end

        it 'has a high level key' do
          result = Redox::Request::PatientAdmin.build_body({Z: 'hi'}, meta)

          assert(result.include?(:Z))
        end
      end

      it 'merges with a default meta' do
        meta = Redox::Models::Meta.new(EventType: 'bob', Test: false)
        result = Redox::Request::PatientAdmin.build_body({}, meta)

        assert_equal('bob', result['Meta']['EventType'])
        assert_equal(false, result['Meta']['Test'])
        assert_equal(false, result['Meta']['EventDateTime'].nil?)
      end

      it 'fails nil meta' do
        assert_raises { Redox::Request::PatientAdmin.build_body({}, nil) }
      end
    end

    describe 'redox calls' do
      before do
        stub_request(:post, /#{Redox::Authentication::BASE_ENDPOINT}/)
          .with(body: hash_including({ apiKey: '123'}))
          .to_return(status: 200, body: { accessToken: 'let.me.in', expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), refreshToken: 'rtoken' }.to_json )

        WebMock.after_request do |request, response|
          @request = request
        end
      end
    end
  end
end
