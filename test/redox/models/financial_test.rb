require 'test_helper'

class FinancialTest < Minitest::Test
  describe 'financial' do
    let(:financial) { Redox::Models::Financial.new(data) }
    let(:data) { {} }
    let(:deserialized) { JSON.parse(financial.to_json) }

    describe 'default' do
      it 'has a patient' do
        assert_equal(Redox::Models::Patient, financial.patient.class)
      end

      it 'has a visit' do
        assert_equal(Redox::Models::Visit, financial.visit.class)
      end

      it 'has an empty array for transactions' do
        assert_equal([], financial.transactions)
      end
    end

    describe 'to_json' do
      describe 'with a transaction' do
        let(:transaction) {
          t = Redox::Models::Transaction.new
          t.add_medication(ndc_code: '0011', description: 'Inject Actemra', quantity: 4, unit: 'ML', magnitude: 142)
        }

        before do
          financial.transactions << transaction
        end

        it 'serializes correctly' do
          assert_equal(Array, deserialized.dig('Transactions').class)
          assert_equal(true, deserialized.dig('Transactions').first.include?('Extensions'))
          assert_equal(true, deserialized.dig('Transactions').first.include?('NDC'))
        end
      end
    end
  end
end
