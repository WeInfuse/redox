require 'test_helper'

class TransactionTest < Minitest::Test
  describe 'transaction' do
    let(:transaction) { Redox::Models::Transaction.new(data) }
    let(:data) { {} }
    let(:deserialized) { JSON.parse(transaction.to_json) }

    describe '#add_medication' do
      describe 'default' do
        let(:extension_data) {
          {
            "ndc-quantity" => {
              "integer" => nil
            },
            "ndc-units-measure" => {
              "coding" => {
                "code" => nil,
                "display" => nil
              }
            }
          }
        }

        it 'has a default' do
          transaction.add_medication
          assert_equal(extension_data, deserialized.dig('Extensions'))
          assert_equal({"Code" => nil, "Description" => nil}, deserialized.dig('NDC'))
        end
      end

      describe 'with data' do
        let(:extension_data) {
          s = <<-DATA
          {
            "ndc-quantity": {
              "integer": "4"
            },
            "ndc-units-measure": {
              "coding": {
                "code": "142",
                "display": "ML"
              }
            }
          }
          DATA
          JSON.parse(s)
        }

        it 'populates correctly' do
          transaction.add_medication(ndc_code: '0011', description: 'Inject Actemra', quantity: 4, unit: 'ML', magnitude: 142)
          assert_equal(extension_data, deserialized.dig('Extensions'))
          assert_equal({"Code" => '0011', "Description" => 'Inject Actemra'}, deserialized.dig('NDC'))
        end
      end
    end

    describe '#add_ordering_provider' do
      it 'takes kwargs' do
        transaction.add_ordering_provider(id: 'cat', id_type: 'FELINE')
        assert_equal([Redox::Models::OrderingProvider.new(id: 'cat', id_type: 'FELINE')], transaction[:OrderingProviders])
        assert_equal([], transaction[:Performers])
      end
    end

    describe '#add_performer' do
      it 'takes kwargs' do
        transaction.add_performer(id: 'dog', id_type: 'CANINE')
        assert_equal([], transaction[:OrderingProviders])
        assert_equal([Redox::Models::OrderingProvider.new(id: 'dog', id_type: 'CANINE')], transaction[:Performers])
      end
    end
  end
end
