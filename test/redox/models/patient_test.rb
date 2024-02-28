require 'test_helper'

class PatientTest < Minitest::Test
  describe 'patient' do
    describe 'demographics' do
      it 'can be initialized' do
        p = Redox::Models::Patient.new('Demographics' => {'FirstName' => 'Joe'})

        assert_equal('Joe', p.Demographics['FirstName'])
      end

      it 'can be built' do
        p = Redox::Models::Patient.new

        p.demographics.first_name = 'Bob'
        assert_equal('Bob', p.Demographics['FirstName'])
      end
    end

    describe 'contacts' do
      it 'can be initialized' do
        p = Redox::Models::Patient.new('Contacts' => [{'FirstName' => 'Peter'}])

        assert_equal('Peter', p.Contacts.first['FirstName'])
      end

      it 'can be built' do
        p = Redox::Models::Patient.new
        p.contacts = [{"FirstName"=>"Barbara", "MiddleName"=>nil, "LastName"=>"Bixby"}]
        assert_equal('Bixby', p.Contacts.first['LastName'])
      end

      it 'can be converted from an array of hashes to Contact objects using method' do
        p = Redox::Models::Patient.new(load_sample('patient_callback.request.json', parse: true))

        assert(p.contacts.first.is_a?(Redox::Models::Contact))
      end
    end

    describe 'pcp' do
      it 'can be initialized' do
        p = Redox::Models::Patient.new('PCP' => {'FirstName' => 'Joe'})

        assert_equal('Joe', p.primary_care_provider['FirstName'])
      end

      it 'can be built' do
        p = Redox::Models::Patient.new

        p.primary_care_provider['FirstName'] = 'Bob'
        assert_equal('Bob', p.primary_care_provider['FirstName'])
      end
    end

    describe 'insurances' do
      it 'can be initialized' do
        p = Redox::Models::Patient.new('Insurances' => [{'Plan' => 'xx'}])

        assert_equal('xx', p.Insurances.first['Plan'])
      end

      it 'can be built' do
        p = Redox::Models::Patient.new

        p.add_insurance(Plan: 'zz')
        assert_equal('zz', p.insurances.first['Plan'])
      end

      it 'can be converted using method' do
        p = Redox::Models::Patient.new(load_sample('patient_callback.request.json', parse: true))

        assert(p.insurances.first.is_a?(Redox::Models::Insurance))
      end
    end

    describe 'identifiers' do
      it 'can be initialized' do
        p = Redox::Models::Patient.new('Identifiers' => [{'ID' => 'xx', 'IDType' => 'BigTime'}])

        assert_equal('xx', p.Identifiers.first['ID'])
        assert_equal('BigTime', p.identifiers.first['IDType'])
      end

      it 'can be built' do
        p = Redox::Models::Patient.new

        p.add_identifier(type: 'MyType', value: 'zz')
        assert_equal('zz', p.identifiers.first['ID'])
        assert_equal('MyType', p.identifiers.first['IDType'])
      end
    end

    describe 'redox calls' do
      before do
        stub_request(:post, /#{Redox::Authentication::AUTH_ENDPOINT}/)
          # .with(body: hash_including({ apiKey: '123'}))
          .to_return(status: 200, body: { access_token: 'let.me.in', expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), refreshToken: 'rtoken' }.to_json )

        WebMock.after_request do |request, response|
          @request = request
        end
      end

      describe '#query' do
        before do
          @query_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Request::PatientSearch::QUERY_ENDPOINT))
            # .with(headers: { 'Authorization' => 'Bearer let.me.in' })
            .to_return(status: 200, body: load_sample('patient_search_single_result.response.json'))
        end

        describe 'request' do
          it 'has an endpoint' do
            Redox::Models::Patient.query({})

            assert_requested(@query_stub, times: 1)
          end

          it 'sends meta' do
            Redox::Models::Patient.query({})

            assert_equal('Query', Redox::Models::Meta.new(JSON.parse(@request.body)).EventType)
            assert_equal('PatientSearch', Redox::Models::Meta.new(JSON.parse(@request.body)).DataModel)
          end
        end

        describe 'response' do
          it 'returns a valid response' do
            response = Redox::Models::Patient.query({})

            assert(response.is_a?(Redox::Models::Model))
          end
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

            assert_equal('NewPatient', Redox::Models::Meta.new(JSON.parse(@request.body)).EventType)
            assert_equal('PatientAdmin', Redox::Models::Meta.new(JSON.parse(@request.body)).DataModel)
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

            assert_equal('PatientUpdate', Redox::Models::Meta.new(JSON.parse(@request.body)).EventType)
            assert_equal('PatientAdmin', Redox::Models::Meta.new(JSON.parse(@request.body)).DataModel)
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
