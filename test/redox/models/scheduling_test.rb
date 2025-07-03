require 'test_helper'

class SchedulingTest < Minitest::Test
  describe 'scheduling' do
    let(:scheduling) { Redox::Models::Scheduling.new(data) }
    let(:data) { {} }

    describe 'default' do
      it 'has a patient' do
        assert_instance_of(Redox::Models::Patient, scheduling.patient)
      end

      it 'has a visit' do
        assert_instance_of(Redox::Models::Visit, scheduling.visit)
      end

      it 'has an empty array for appointment_info' do
        assert_empty(scheduling.appointment_info)
      end
    end

    describe 'to_json' do
      describe 'with appointment info' do
        let(:deserialized) { JSON.parse(scheduling.to_json) }
        let(:info) { { Code: 'abc123', Codeset: 'My Codeset!', Description: 'catscatscats', Value: 'meow' } }
        let(:deserialized_infos) { deserialized['AppointmentInfo'] }
        let(:deserialized_info) { deserialized_infos.last }

        describe 'manual add' do
          before do
            scheduling.appointment_info << info
          end

          it 'serializes correctly' do
            assert_instance_of(Array, deserialized_infos)
            assert_equal(info[:Code], deserialized_info['Code'])
            assert_equal(info[:Codeset], deserialized_info['Codeset'])
            assert_equal(info[:Description], deserialized_info['Description'])
            assert_equal(info[:Value], deserialized_info['Value'])
          end
        end

        describe 'helper add' do
          before do
            scheduling.add_appointment_info(code: info[:Code], codeset: info[:Codeset],
                                            description: info[:Description], value: info[:Value])
          end

          it 'serializes correctly' do
            assert_instance_of(Array, deserialized_infos)
            assert_equal(info[:Code], deserialized_info['Code'])
            assert_equal(info[:Codeset], deserialized_info['Codeset'])
            assert_equal(info[:Description], deserialized_info['Description'])
            assert_equal(info[:Value], deserialized_info['Value'])
          end
        end
      end
    end
  end
end
