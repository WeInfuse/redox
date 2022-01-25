require 'test_helper'

class MedicationsTest < Minitest::Test
  describe 'medications' do
    let(:medications) { Redox::Models::Medications.new(data) }
    let(:data) { {} }

    describe 'default' do
      it 'has a patient' do
        assert_equal(Redox::Models::Patient, medications.patient.class)
      end

      it 'has a visit' do
        assert_equal(Redox::Models::Visit, medications.visit.class)
      end

      it 'has an empty array for administrations' do
        assert_equal([], medications.administrations)
      end
    end

    describe 'administrations' do
      it 'can be initialized' do
        m = Redox::Models::Medications.new('Administrations' => [{'Status' => 'Complete'}])

        assert_equal('Complete', m.Administrations.first['Status'])
      end

      it 'can be built' do
        m = Redox::Models::Medications.new
        m.administrations = [{"Status"=>"Complete", "Medication"=>{"Product"=>{"Code"=>"12341234"}}}]
        assert_equal('Complete', m.Administrations.first['Status'])
      end
    end
  end
end
