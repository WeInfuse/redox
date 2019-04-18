require 'test_helper'

class MetaTest < Minitest::Test
  def setup
    @subscription_h = {
      'Name' => 'Mike',
      'ID' => '100'
    }
  end

  def test_has_default_meta
    expected = Redox::Models::Meta::DEFAULT.call
    actual   = Redox::Models::Meta.new.to_h

    expected['Meta'].delete('EventDateTime')

    timestamp = actual['Meta'].delete('EventDateTime')

    assert_equal("2019-04-17T19:33:26.563008Z".size, timestamp.size)
    assert_equal(expected, actual)
  end

  def test_can_add_destination
    assert_equal([@subscription_h, @subscription_h],
                 Redox::Models::Meta.new.add_destination('Mike', '100').add_destination('Mike', '100').inner['Destinations']
                )
  end

  def test_can_set_source
    assert_equal(@subscription_h, Redox::Models::Meta.new.set_source('Mike', '100').inner['Source'])
  end

  def test_can_assign_source
    meta = Redox::Models::Meta.new
    meta.source = Redox::Models::Meta.build_subscription('Mike', '100')

    assert_equal(@subscription_h, meta.inner['Source'])
  end

  def test_default_test_settings_is_true
    assert(Redox::Models::Meta.new.inner['Test'])
  end

  def test_can_set_test
    meta = Redox::Models::Meta.new
    meta.test = false

    assert(false == meta.inner['Test'])

    meta.test = true

    assert(meta.inner['Test'])
  end

  def test_can_set_test_non_boolean_are_false
    meta = Redox::Models::Meta.new

    meta.test = 'cow'

    assert(false == meta.inner['Test'])
  end

  def test_can_return_hash
    assert(Redox::Models::Meta.new.to_h.is_a?(Hash))
    assert(Redox::Models::Meta.new.to_h[Redox::Models::Meta::KEY].is_a?(Hash))
  end

  def test_merge_can_merge_two_metas
    a = Redox::Models::Meta.new
    b = Redox::Models::Meta.new
    a.set_source('Mike', '123')
    b.add_destination('Pike', '321')
    expected = a.to_h[Redox::Models::Meta::KEY].merge(b.to_h[Redox::Models::Meta::KEY])

    assert_equal({ Redox::Models::Meta::KEY => expected }, a.merge(b).to_h)
  end

  def test_merge_can_merge_a_hash_with_meta_key
    a = Redox::Models::Meta.new
    b = { Redox::Models::Meta::KEY => {'Destinations' => ['x']} }
    expected = a.to_h[Redox::Models::Meta::KEY].merge(b[Redox::Models::Meta::KEY])

    assert_equal({ Redox::Models::Meta::KEY => expected }, a.merge(b).to_h)
  end

  def test_merge_can_merge_a_hash_with_no_meta_key
    a = Redox::Models::Meta.new
    b = { 'Destinations' => ['x']}
    expected = a.to_h[Redox::Models::Meta::KEY].merge(b)

    assert_equal({ Redox::Models::Meta::KEY => expected }, a.merge(b).to_h)
  end

  def test_merging_hash_can_overwrite_with_nil_values
    a = Redox::Models::Meta.new
    a.set_source('Mike', '123')
    b = { 'Source' => nil}
    expected = a.to_h[Redox::Models::Meta::KEY].merge(b)

    assert_equal({ Redox::Models::Meta::KEY => expected }, a.merge(b).to_h)
  end

  def test_merging_meta_ignores_nil_values
    a = Redox::Models::Meta.new
    b = Redox::Models::Meta.new
    a.set_source('Mike', '123')
    b.source = nil
    expected = a.to_h[Redox::Models::Meta::KEY].merge(b.to_h[Redox::Models::Meta::KEY].select {|k,v| !v.nil?})

    assert_equal({ Redox::Models::Meta::KEY => expected }, a.merge(b).to_h)
  end

  def test_can_build_subscription
    assert_equal(@subscription_h, Redox::Models::Meta.build_subscription('Mike', '100'))
  end

  def test_can_create_from_hash
    a = Redox::Models::Meta.from_h(Redox::Models::Meta::DEFAULT.call).inner.select {|k,v| k != 'EventDateTime'}
    b = Redox::Models::Meta.new.inner.select {|k,v| k != 'EventDateTime'}

    assert_equal(a, b)
  end
end
