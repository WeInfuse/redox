require 'test_helper'

class ModelTest < Minitest::Test
  SAMPLE_DATA = {
    "X" => {
      "Y" => {
        "Z" => "ZVAL"
      }
    },
    "M" => "MVAL"
  }

  def setup
    @sample = Redox::Models::Model.new(SAMPLE_DATA)
  end

  def test_map_understands_strings
    assert_equal({mvalue: "MVAL"}, @sample.map(mapper: {"M" => :mvalue}))
  end

  def test_map_can_traverse_nested_hashes
    mapper = {
      "X" => {
        "Y" => {
          "Z" => :zvalue
        }
      }
    }

    assert_equal({zvalue: "ZVAL"}, @sample.map(mapper: mapper))
  end

  def test_map_understands_lambdas
    my_lambda = ->(val) {
      return { mvalue_key: "#{val}:#{val}" }
    }

    assert_equal(my_lambda.call("MVAL"), @sample.map(mapper: {"M" => my_lambda}))
  end

  def test_map_throws_with_mappers_that_arent_hashes
    e = assert_raises { @sample.map(mapper: "bob") }

    assert_match(/mapper must be a hash/, e.message)
  end

  def test_map_throws_with_lambdas_that_dont_return_hashes
    my_lambda = ->(val) {
      return "#{val}:#{val}"
    }

    e = assert_raises { @sample.map(mapper: {"M" => my_lambda}) }

    assert_match(/lambda must return hash/, e.message)
  end
end
