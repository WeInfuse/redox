require 'test_helper'

class ProviderTest < Minitest::Test
  describe 'Provider' do
    describe 'redox calls' do
      let(:request_body) { JSON.parse(@request.body) }

      before do
        stub_redox(body: sample)

        WebMock.after_request do |request, _response|
          @request = request
        end
      end

      describe '#query' do
        let(:sample) { load_sample('provider_search.response.json', parse: true) }
        let(:provider) do
          p = Redox::Models::Provider.new
          p.demographics.last_name = 'Ronnerson'
          p.add_identifier(type: 'NPI', value: '88889999')
          p
        end

        describe 'request' do
          it 'has an endpoint' do
            Redox::Request::Provider.query(provider)

            assert_requested(@post_stub, times: 1)
          end

          it 'sends meta' do
            Redox::Request::Provider.query(provider)

            assert_equal('ProviderQuery', Redox::Models::Meta.new(request_body).EventType)
            assert_equal('Provider', Redox::Models::Meta.new(request_body).DataModel)
          end

          it 'sends data' do
            Redox::Request::Provider.query(provider)

            assert_equal(false, request_body['Provider'].nil?)
            assert_equal('Ronnerson', request_body.dig('Provider', 'Demographics', 'LastName'),
                         request_body['Provider'])
            assert_equal('88889999', request_body.dig('Provider', 'Identifiers').first['ID'])
          end
        end

        describe 'response' do
          it 'returns a valid response' do
            response = Redox::Request::Provider.query(provider)

            assert_kind_of(Redox::Models::Model, response)
            assert_kind_of(Array, response.providers)
          end
        end
      end
    end
  end
end
