require 'test_helper'

class PotentialMatchesTest < Minitest::Test
  describe 'potential matches' do
    let(:matches) { Redox::Models::PotentialMatches.new(data) }

    describe '#initialize' do
      describe 'nil' do
        let(:data) { nil }

        it 'returns empty array' do
          assert_empty(matches)
        end
      end

      describe 'with patient data' do
        let(:data) { load_sample('patient_search_multiple_matches.response.json', parse: true)['PotentialMatches'] }

        it 'returns array of patients' do
          assert_equal(2, matches.size)
        end

        describe 'items in array' do
          it 'the array has Patient models' do
            assert_instance_of(Redox::Models::Patient, matches.first)
          end

          it 'has data' do
            assert_equal('Test', matches.first.demographics.last_name)
          end
        end
      end
    end
  end
end
