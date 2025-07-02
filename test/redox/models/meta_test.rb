require 'test_helper'

class MetaTest < Minitest::Test
  describe 'meta' do
    before do
      @subscription_h = {
        'Name' => 'Mike',
        'ID' => '100'
      }
    end

    describe 'defaults' do
      it 'provides event date time' do
        assert_equal('2019-04-17T19:33:26.563008Z'.size, Redox::Models::Meta.new[:EventDateTime].size)
      end

      it 'provides test' do
        assert_equal(true, Redox::Models::Meta.new[:Test])
      end

      it 'has correct key' do
        result = JSON.parse(Redox::Models::Meta.new.to_json)

        assert_includes(result, 'Meta')
      end
    end

    it 'can add destinations' do
      assert_equal([@subscription_h, @subscription_h],
                   Redox::Models::Meta.new.add_destination(name: 'Mike', id: '100').add_destination(name: 'Mike',
                                                                                                    id: '100')['Destinations'])
    end

    it 'can set source' do
      assert_equal(@subscription_h, Redox::Models::Meta.new.set_source(name: 'Mike', id: '100')['Source'])
    end

    it 'merge two metas' do
      a = Redox::Models::Meta.new
      b = Redox::Models::Meta.new
      e = Redox::Models::Meta.new

      a.set_source(name: 'Mike', id: '123')
      e.set_source(name: 'Mike', id: '123')
      b.add_destination(name: 'Pike', id: '321')
      e.add_destination(name: 'Pike', id: '321')
      e.event_date_time = b['EventDateTime']

      assert_equal(e.to_json, a.merge(b).to_json)
    end

    it 'test_can_build_subscription' do
      assert_equal(@subscription_h, Redox::Models::Meta.build_subscription(name: 'Mike', id: '100'))
    end
  end
end
