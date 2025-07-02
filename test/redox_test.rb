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
      assert_kind_of(Redox::Connection, Redox::RedoxClient.connection)
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
      api_key: 'a',
      secret: 'b',
      api_endpoint: 'http://hi.com',
      token_expiry_padding: 123
    }.each do |method, value|
      it "can set #{method} via configuration" do
        assert_respond_to(Redox.configuration, method)
        Redox.configuration.send("#{method}=", value)

        assert_equal(value, Redox.configuration.send(method.to_s))
      end

      it "can set #{method} via configure block" do
        Redox.configure do |c|
          assert_respond_to(c, method)
          c.send("#{method}=", value)

          assert_equal(value, Redox.configuration.send(method.to_s))
        end
      end
    end
  end
end
