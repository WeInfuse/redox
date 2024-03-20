require 'test_helper'

class VisitTest < Minitest::Test
  describe 'visit' do
    let(:visit) { Redox::Models::Visit.new(data) }
    let(:deserialized) { JSON.parse(visit.to_json) }
    let(:visit_as_json) { visit.as_json }
    let(:data) { {} }

    describe 'insurances' do
      describe 'hash initialization' do
        let(:data) { {'Insurances' => [{'Plan' => 'xx'}]} }

        it 'can be initialized' do
          assert_equal('xx', visit.Insurances.first['Plan'])
        end
      end

      describe 'response data' do
        let(:data) { patient_admin_responses(:visit_update) }

        it 'can be converted using method' do
          assert_equal(Redox::Models::Insurance, visit.insurances.first.class)
        end
      end
    end

    describe 'Location' do
      describe '#department=' do
        it 'is a helper to create Location[:Department]' do
          visit.department = 'CatCity'

          assert_equal('CatCity', visit[:Location][:Department])
        end
      end

      describe '#facility=' do
        it 'is a helper to create Location[:Facility]' do
          visit.facility = 'A Bad Place'

          assert_equal('A Bad Place', visit[:Location][:Facility])
        end
      end
    end

    describe 'AttendingProvider' do
      describe '#attending_provider_id=' do
        it 'is a helper to create AttendingProvider[:ID]' do
          visit.attending_provider_id = '234'

          assert_equal('234', visit[:AttendingProvider][:ID])
        end
      end

      describe '#attending_provider_id_type=' do
        it 'is a helper to create AttendingProvider[:IDType]' do
          visit.attending_provider_id_type = 'Profile ID'

          assert_equal('Profile ID', visit[:AttendingProvider][:IDType])
        end
      end

      describe '#attending_provider_first_name=' do
        it 'is a helper to create AttendingProvider[:FirstName]' do
          visit.attending_provider_first_name = 'Joe'

          assert_equal('Joe', visit[:AttendingProvider][:FirstName])
        end
      end

      describe '#attending_provider_last_name=' do
        it 'is a helper to create AttendingProvider[:LastName]' do
          visit.attending_provider_last_name = 'King'

          assert_equal('King', visit[:AttendingProvider][:LastName])
        end
      end
    end

    describe 'ReferringProvider' do
      describe '#referring_provider_id=' do
        it 'is a helper to create ReferringProvider[:ID]' do
          visit.referring_provider_id = '123'

          assert_equal('123', visit[:ReferringProvider][:ID])
        end
      end

      describe '#referring_provider_id_type=' do
        it 'is a helper to create ReferringProvider[:IDType]' do
          visit.referring_provider_id_type = 'NPI'

          assert_equal('NPI', visit[:ReferringProvider][:IDType])
        end
      end

      describe '#referring_provider_first_name=' do
        it 'is a helper to create ReferringProvider[:FirstName]' do
          visit.referring_provider_first_name = 'May'

          assert_equal('May', visit[:ReferringProvider][:FirstName])
        end
      end

      describe '#referring_provider_last_name=' do
        it 'is a helper to create ReferringProvider[:LastName]' do
          visit.referring_provider_last_name = 'Bee'

          assert_equal('Bee', visit[:ReferringProvider][:LastName])
        end
      end
    end

    describe '#add_equipment' do
      it 'will add equipment' do
        visit.add_equipment(description: 'cats and cats', code: 'meowzers')

        assert_equal(1, visit.Equipment.size)
        assert_equal({Description: 'cats and cats', Code: 'meowzers'}, visit.Equipment[0])
      end
    end

    describe 'visit date' do
      describe '#start' do
        it 'is a helper to VisitDateTime' do
          visit.start = 'cats'

          assert_equal('cats', visit[:VisitDateTime])
        end
      end

      describe 'serialization' do
        let(:data) { { 'VisitDateTime' => datetime } }

        describe 'date or time object' do
          let(:datetime) { Time.now }

          describe '#to_json' do
            it 'converts to redox format' do
              assert_equal(datetime.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), deserialized.dig('Visit', 'VisitDateTime'))
            end
          end

          describe '#as_json' do
            it 'converts to redox format' do
              assert_equal(datetime.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), visit_as_json.dig('VisitDateTime'))
            end
          end
        end

        describe 'string object' do
          let(:datetime) { '2020-04-05T11:38:41.483' }

          describe '#to_json' do
            it 'leaves it be' do
              assert_equal(datetime, deserialized.dig('Visit', 'VisitDateTime'))
            end
          end

          describe '#as_json' do
            it 'leaves it be' do
              assert_equal(datetime, visit_as_json.dig('VisitDateTime'))
            end
          end
        end

        describe 'nil' do
          let(:datetime) { nil }

          it 'leaves it be' do
            assert_nil(deserialized.dig('Visit', 'VisitDateTime'))
          end
        end
      end
    end

    describe 'discharge date' do
      describe '#end' do
        it 'is a helper to DischargeDateTime' do
          visit.end = 'dogs'

          assert_equal('dogs', visit[:DischargeDateTime])
        end
      end

      describe 'serialization' do
        let(:data) { { 'DischargeDateTime' => datetime } }

        describe 'date or time object' do
          let(:datetime) { Time.now }

          describe '#to_json' do
            it 'converts to redox format' do
              assert_equal(datetime.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), deserialized.dig('Visit', 'DischargeDateTime'))
            end
          end

          describe '#as_json' do
            it 'converts to redox format' do
              assert_equal(datetime.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), visit_as_json.dig('DischargeDateTime'))
            end
          end
        end

        describe 'string object' do
          let(:datetime) { '2020-04-05T12:38:41.483' }

          describe '#to_json' do
            it 'leaves it be' do
              assert_equal(datetime, deserialized.dig('Visit', 'DischargeDateTime'))
            end
          end

          describe '#as_json' do
            it 'leaves it be' do
              assert_equal(datetime, visit_as_json.dig('DischargeDateTime'))
            end
          end
        end

        describe 'nil' do
          let(:datetime) { nil }

          it 'leaves it be' do
            assert_nil(deserialized.dig('Visit', 'DischargeDateTime'))
          end
        end
      end
    end
  end
end
