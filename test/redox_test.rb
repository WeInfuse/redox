require 'test_helper'

class RedoxTest < Minitest::Test
  PATIENT = {
      Identifiers: [],
      Demographics: {
        FirstName: 'Joe'
      }
  }.freeze

  describe 'redox' do
    it 'has a version' do
      refute_nil ::Redox::VERSION
    end
  end

  describe '#connection' do
    it 'sets a default expiry padding' do
      Redox.configuration.token_expiry_padding = nil
      Redox::RedoxClient.connection
      assert_equal(60, Redox.configuration.token_expiry_padding)
    end

    it 'returns a connection object' do
      assert(Redox::RedoxClient.connection.is_a?(Redox::Connection))
    end
  end

  describe 'configuration' do
    before do
      @config = Redox.configuration.to_h
    end

    after do
      Redox.configuration.from_h(@config)
    end

    {
      fhir_client_id: 'a',
      fhir_private_key: 'b',
      api_endpoint: 'http://hi.com',
      token_expiry_padding: 123
    }.each do |method, value|
      it "can set #{method} via configuration" do
        assert(Redox.configuration.respond_to?(method))
        Redox.configuration.send("#{method}=", value)

        assert_equal(value, Redox.configuration.send("#{method}"))
      end

      it "can set #{method} via configure block" do
        Redox.configure do |c|
          assert(c.respond_to?(method))
          c.send("#{method}=", value)

          assert_equal(value, Redox.configuration.send("#{method}"))
        end
      end
    end
  end
end
