require 'test_helper'

class PatientAdminTest < Minitest::Test
  describe 'PatientAdmin' do
    let(:meta) { Redox::Models::Meta.new }
    let(:request_body) { JSON.parse(@request.body) }

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

      describe '#create' do
        before do
          create_sample = load_sample('patient_search_single_result.response.json', parse: true)
          create_sample['Meta'].merge!(Redox::Request::PatientAdmin::CREATE_META)

          @create_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
            .with(body: hash_including('Meta' => hash_including('EventType' => 'NewPatient')))
            .to_return(status: 200, body: create_sample.to_json)
        end

        describe 'request' do
          it 'has an endpoint' do
            Redox::Models::Patient.new.create()

            assert_requested(@create_stub, times: 1)
          end

          it 'sends meta' do
            Redox::Models::Patient.new.create()

            assert_equal('NewPatient', Redox::Models::Meta.new(request_body).EventType)
            assert_equal('PatientAdmin', Redox::Models::Meta.new(request_body).DataModel)
          end

          it 'sends patient' do
            Redox::Models::Patient.new(Demographics: { FirstName: 'bob' }).create()

            assert_equal('bob', Redox::Models::Patient.new(request_body).demographics.first_name)
          end
        end

        describe 'response' do
          it 'returns a valid response' do
            response = Redox::Models::Patient.new.create()

            assert(response.is_a?(Redox::Models::Model))
          end
        end
      end

      describe '#update' do
        before do
          update_sample = load_sample('patient_search_single_result.response.json', parse: true)
          update_sample['Meta'].merge!(Redox::Request::PatientAdmin::UPDATE_META)

          @update_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
            .with(body: hash_including('Meta' => hash_including('EventType' => 'PatientUpdate')))
            .to_return(status: 200, body: update_sample.to_json)
        end

        describe 'request' do
          it 'has an endpoint' do
            Redox::Models::Patient.new.update()

            assert_requested(@update_stub, times: 1)
          end

          it 'sends meta' do
            Redox::Models::Patient.new.update()

            assert_equal('PatientUpdate', Redox::Models::Meta.new(request_body).EventType)
            assert_equal('PatientAdmin', Redox::Models::Meta.new(request_body).DataModel)
          end

          it 'sends patient' do
            Redox::Models::Patient.new(Demographics: { FirstName: 'bob' }).update()

            assert_equal('bob', Redox::Models::Patient.new(request_body).demographics.first_name)
          end
        end

        describe 'response' do
          it 'returns a valid response' do
            response = Redox::Models::Patient.new.update()

            assert(response.is_a?(Redox::Models::Model))
          end
        end
      end
    end
  end
end
