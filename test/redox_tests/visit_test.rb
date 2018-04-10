require 'test_helper'

class VisitTest < Minitest::Test
  def test_attributes_map_from_response
    v = Redox::Visit.new(visit)
    assert_equal([
                   {
                     id: 108
                   }
                 ], v.attending_providers)
    assert_equal([{
                   department: 150
                 }], v.locations)
  end
end
