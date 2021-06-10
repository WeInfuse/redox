require 'test_helper'

module Request
   class NotesTest < Minitest::Test
      describe 'Notes Redox Calls' do
         let(:request_body) { JSON.parse(@actual_request.body) }
         let(:sample) { load_sample('notes.response.json', parse: true) }
         let(:notes) { Redox::Models::Notes.new(data) }
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
            let(:request) { Redox::Request::Notes.create(notes) }

            describe 'request' do
               it 'has an endpoint' do
                  assert_requested(@post_stub, times: 1)
               end
               
               it 'sends meta' do
                  assert_equal('New', Redox::Models::Notes.new(request_body).Meta['EventType'])
                  assert_equal('Notes', Redox::Models::Notes.new(request_body).Meta['DataModel'])
               end

               it 'returns a valid response' do
                  assert(response.is_a?(Redox::Models::Model))
               end
            end
         end
      end
   end
end