require 'test_helper'

class FinancialTest < Minitest::Test
  describe 'Financial' do
    describe 'redox calls' do
      let(:request_body) { JSON.parse(@request.body) }

      before do
        stub_redox(body: sample)

        WebMock.after_request do |request, _response|
          @request = request
        end
      end

      describe '#create' do
        let(:sample) { load_sample('financial_transaction.response.json', parse: true) }
        let(:financial) { Redox::Models::Financial.new(data) }
        let(:data) { {} }

        describe 'request' do
          it 'has an endpoint' do
            Redox::Request::Financial.create(financial)

            assert_requested(@post_stub, times: 1)
          end

          it 'sends meta' do
            Redox::Request::Financial.create(financial)

            assert_equal('Transaction', Redox::Models::Meta.new(request_body).EventType)
            assert_equal('Financial', Redox::Models::Meta.new(request_body).DataModel)
          end

          it 'sends data' do
            Redox::Request::Financial.create(financial)

            assert_empty(request_body['Transactions'])
            assert_equal(false, request_body['Patient'].nil?)
            assert_equal(false, request_body['Visit'].nil?)
          end
        end

        describe 'response' do
          it 'returns a valid response' do
            response = Redox::Request::Financial.create(financial)

            assert_kind_of(Redox::Models::Model, response)
          end
        end
      end
    end
  end
end
