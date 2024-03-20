require 'test_helper'

class ConnectionTest < Minitest::Test
  describe 'connection' do
    before do
      auth_stub

      @authorized_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
        .with(headers: { 'Authorization' => 'Bearer let.me.in' })
        .to_return(status: 200, body: {}.to_json)

      @stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
        .to_return(status: 200, body: {}.to_json)

      @connection = Redox::Connection.new

      WebMock.after_request do |request, response|
        @request = request
      end
    end

    describe 'auth option' do
      it 'defaults to sending auth header' do
        @connection.request

        assert_requested(@auth_stub, times: 1)
        assert_requested(@authorized_stub, times: 1)
      end

      it 'false omits auth header' do
        @connection.request(auth: false)

        assert_requested(@stub, times: 1)
      end
    end

    it 'returns response' do
      response = @connection.request

      assert(response.ok?)
      assert_equal({}, response.parsed_response)
      assert_equal('{}', response.body)
    end

    it 'changes body to json for hashes' do
      @connection.request(auth: false, body: {h: 10})

      assert_requested(@stub, times: 1)
      assert_equal({h:10}.to_json, @request.body)
    end

    it 'changes body to json for hashes' do
      @connection.request(auth: false, body: 'hi')

      assert_requested(@stub, times: 1)
      assert_equal('hi', @request.body)
    end

    it 'passes headers' do
      @connection.request(headers: {'x' => '10'})

      assert_requested(@stub, times: 1)
      assert_equal('10', @request.headers['X'])
    end

    it 'has precedence over auth header' do
      @connection.request(headers: {'Authorization' => 'eep'})

      assert_requested(@stub, times: 1)
      assert_equal('eep', @request.headers['Authorization'])
    end
  end
end
