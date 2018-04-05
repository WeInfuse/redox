require 'test_helper'

class VisitTest < Minitest::Test
  def test_attributes_map_from_response
    v = RedoxEngine::Visit.new(visit)
    assert_equal([
                   {
                     id: 108
                   }
                 ], v.attending_providers)
    assert_equal({
                   department: 150
                 }, v.location)
  end
end
