require 'test_helper'

class PatientAdminTest < Minitest::Test
  describe 'PatientAdmin' do
    describe 'redox calls' do
      let(:request_body) { JSON.parse(@request.body) }

      before do
        stub_redox(body: sample)

        WebMock.after_request do |request, response|
          @request = request
        end
      end

      describe '#create' do
        let(:sample) {
          s = load_sample('patient_search_single_result.response.json', parse: true)
          s['Meta'].merge!(Redox::Request::PatientAdmin::CREATE_META)
          s
        }

        describe 'request' do
          it 'has an endpoint' do
            Redox::Models::Patient.new.create()

            assert_requested(@post_stub, times: 1)
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
        let(:sample) {
          s = load_sample('patient_search_single_result.response.json', parse: true)
          s['Meta'].merge!(Redox::Request::PatientAdmin::UPDATE_META)
          s
        }

        describe 'request' do
          it 'has an endpoint' do
            Redox::Models::Patient.new.update()

            assert_requested(@post_stub, times: 1)
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
