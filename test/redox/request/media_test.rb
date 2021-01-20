require 'test_helper'

module Request
  class MediaTest < Minitest::Test
    describe 'MediaUpload' do
      describe 'redox calls' do
        let(:request_body) { JSON.parse(@actual_request.body) }
        let(:sample) { load_sample('media.response.json', parse: true) }
        let(:media_upload) { Redox::Models::MediaUpload.new(data) }
        let(:response) { request }
        let(:data) { {} }

        before do
          stub_redox(body: sample)

          WebMock.after_request do |actual_request, actual_response|
            @actual_request = actual_request
          end

          request
        end

        describe '#create' do
          let(:request) { Redox::Request::Media.create(media_upload) }

          describe 'request' do
            it 'has an endpoint' do
              assert_requested(@post_stub, times: 1)
            end

            it 'sends meta' do
              assert_equal('New', Redox::Models::Meta.new(request_body).EventType)
              assert_equal('Media', Redox::Models::Meta.new(request_body).DataModel)
            end

            it 'sends data' do
              assert_equal(false, request_body['Media'].nil?)
              assert_equal(false, request_body['Patient'].nil?)
              assert_equal(false, request_body['Visit'].nil?)
            end
          end

          describe 'response' do
            it 'returns a valid response' do
              assert(response.is_a?(Redox::Models::Model))
            end
          end
        end
      end
    end
  end
end
