require 'test_helper'

class MedicationsTest < Minitest::Test
  describe 'medications' do
    let(:medications) { Redox::Models::Medications.new(data) }
    let(:data) { {} }

    describe 'default' do
      it 'has a patient' do
        assert_instance_of(Redox::Models::Patient, medications.patient)
      end

      it 'has a visit' do
        assert_instance_of(Redox::Models::Visit, medications.visit)
      end

      it 'has an empty array for administrations' do
        assert_empty(medications.administrations)
      end
    end

    describe 'administrations' do
      it 'can be initialized' do
        m = Redox::Models::Medications.new('Administrations' => [{ 'Status' => 'Complete' }])

        assert_equal('Complete', m.Administrations.first['Status'])
      end

      it 'can be built' do
        m = Redox::Models::Medications.new
        m.administrations = [{ 'Status' => 'Complete', 'Medication' => { 'Product' => { 'Code' => '12341234' } } }]

        assert_equal('Complete', m.Administrations.first['Status'])
      end
    end
  end
end
