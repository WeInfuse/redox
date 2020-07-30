require 'test_helper'

class VisitTest < Minitest::Test
  describe 'visit' do
    describe 'insurances' do
      it 'can be initialized' do
        p = Redox::Models::Visit.new('Insurances' => [{'Plan' => 'xx'}])

        assert_equal('xx', p.Insurances.first['Plan'])
      end

      it 'can be converted using method' do
        p = Redox::Models::Visit.new(patient_admin_responses(:visit_update))

        assert_equal(Redox::Models::Insurance, p.insurances.first.class)
      end
    end
  end
end
