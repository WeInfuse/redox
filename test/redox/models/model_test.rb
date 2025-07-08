require 'test_helper'

module Redox
  module Models
    class AbstractModel < Hashie::Trash
      property :HelloWorld, from: :hello_world
    end
  end
end

module Redox
  module Models
    class RipeBanana < Hash
    end
  end
end

class SimpleFakeResponse < Hash
  # rubocop:disable Naming/MethodParameterName
  def initialize(data: {}, ok: true)
    h    = { parsed_response: data, ok: ok }
    data = { __junk__: data } unless data.is_a?(Hash)

    super(h.merge(data))
  end
  # rubocop:enable Naming/MethodParameterName

  def ok?
    self[:ok] || true
  end

  def parsed_response
    self[:parsed_response]
  end
end

# rubocop:disable Metrics/ClassLength
class ModelTest < Minitest::Test
  describe 'abstract model' do
    describe '#to_json' do
      it 'has no top level key' do
        z = Redox::Models::AbstractModel.new
        z[:HelloWorld] = 10

        assert_equal({ HelloWorld: 10 }.to_json, z.to_json)
      end
    end
  end

  describe 'model' do
    describe 'removes top level key' do
      it 'works for string' do
        z = Redox::Models::Model.new('Model' => { HelloWorld: 50 })

        assert_equal(50, z['HelloWorld'])
      end

      it 'works for symbols' do
        z = Redox::Models::Model.new(Model: { HelloWorld: 50 })

        assert_equal(50, z['HelloWorld'])
      end
    end

    it 'ignores undeclared' do
      z = Redox::Models::Model.new({ other: 50 })

      assert_raises(StandardError) { z[:other] }
    end

    it 'has indifferent access hash' do
      z = Redox::Models::Model.new
      z['HelloWorld'] = 10
      z[:HelloWorld]  = 20

      assert_equal(z[:HelloWorld], z['HelloWorld'])
    end

    it 'can deep merge' do
      y = Redox::Models::Model.new
      z = Redox::Models::Model.new
      y[:HelloWorld] = { i: { j: 20 } }
      z[:HelloWorld] = { i: { j: 10 } }

      assert_equal(y, z.merge(y))
    end

    it 'can use camel or snake case' do
      y = Redox::Models::Model.new(hello_world: 10)
      z = Redox::Models::Model.new(HelloWorld: 10)

      assert_equal(y, z)
    end

    it 'can methods instead' do
      y = Redox::Models::Model.new
      z = Redox::Models::Model.new
      y.hello_world = 10
      z.HelloWorld = 10

      assert_equal(y, z)
    end

    describe '#to_json' do
      it 'adds top level key to hash' do
        z = Redox::Models::Model.new
        z[:HelloWorld] = 10

        assert_equal({ 'Model' => { HelloWorld: 10 } }.to_json, z.to_json)
      end
    end

    describe '#from_response' do
      let(:model) { Redox::Models::Model.from_response(model_data) }

      describe 'response' do
        let(:model_data) { 'bob' }

        it 'adds' do
          assert_equal(model_data, model.response)
        end
      end

      describe 'patient' do
        let(:model_data) { { 'Patient' => { 'Demographics' => { 'FirstName' => 'Charles' } } } }

        it 'adds' do
          assert_equal('Charles', model.patient.demographics.first_name)
        end
      end

      describe 'visit' do
        let(:model_data) { { 'Visit' => { 'Insurances' => ['PolicyNumber' => '1277777'] } } }

        it 'adds' do
          assert_equal(1, model.visit.insurances.size)
        end
      end

      describe 'meta' do
        let(:model_data) { { 'Meta' => { 'FacilityCode' => '09' } } }

        it 'adds' do
          assert_equal('09', model.meta.facility_code)
        end
      end

      describe 'potential matches' do
        let(:model_data) { { 'PotentialMatches' => [{ 'FirstName' => 'bob1' }, { 'FirstName' => 'bob2' }] } }

        it 'adds' do
          assert_equal(2, model.potential_matches.size)
        end
      end

      describe 'insurances helper' do
        let(:model_data) { 'bob' }

        describe 'no insurances' do
          it 'returns empty arrray' do
            assert_empty(model.insurances)
          end
        end

        describe 'patient' do
          let(:model_data) { { 'Patient' => { 'Insurances' => ['PolicyNumber' => '0123'] } } }

          it 'uses the patient insurances' do
            assert_equal('0123', model.insurances.first.policy_number)
          end
        end

        describe 'visit' do
          let(:model_data) { { 'Visit' => { 'Insurances' => ['PolicyNumber' => '3210'] } } }

          it 'uses the visit insurances' do
            assert_equal('3210', model.insurances.first.policy_number)
          end
        end

        describe 'patient and visit' do
          let(:model_data) do
            {
              'Patient' => { 'Insurances' => ['PolicyNumber' => '0123'] },
              'Visit' => { 'Insurances' => ['PolicyNumber' => '3210'] }
            }
          end

          it 'concats' do
            assert_equal('0123', model.insurances.first.policy_number)
            assert_equal('3210', model.insurances.last.policy_number)
          end
        end
      end
    end

    describe '#from_response_inflected' do
      let(:model) { Redox::Models::Model.from_response_inflected(fake_response) }
      let(:ok?) { true }
      let(:fake_response) { SimpleFakeResponse.new(data: model_data, ok: ok?) }

      describe 'high level not a hash' do
        let(:model_data) { :cat }

        it 'will does not fail' do
          assert_equal(fake_response, model.response)
        end
      end

      describe 'high level is hash' do
        describe 'key with array data' do
          let(:meta) { {} }
          let(:model_data) do
            meta.merge(
              BaNanas: [{ z: 'm' }, { z: 'x' }]
            )
          end

          it 'adds #bananas' do
            assert_equal([{ z: 'm' }, { z: 'x' }], model.bananas)
          end

          describe 'array is of meta.DataModel type' do
            let(:data_model) { :Banana }
            let(:meta) { { Meta: { DataModel: data_model } } }

            describe 'model exists' do
              let(:data_model) { 'RipeBanana' }

              it 'converts objects to type' do
                assert_instance_of(Redox::Models::RipeBanana, model.bananas.last)
              end
            end

            describe 'model does not exist' do
              it 'leaves it alone' do
                assert_instance_of(Hash, model.bananas.last)
              end
            end
          end
        end
      end

      describe 'does all the #from_response stuff' do
        describe 'response' do
          let(:model_data) { 'bob' }

          it 'adds' do
            assert_equal(fake_response, model.response)
          end
        end

        describe 'patient' do
          let(:model_data) { { 'Patient' => { 'Demographics' => { 'FirstName' => 'Charles' } } } }

          it 'adds' do
            assert_equal('Charles', model.patient.demographics.first_name)
          end
        end

        describe 'visit' do
          let(:model_data) { { 'Visit' => { 'Insurances' => ['PolicyNumber' => '1277777'] } } }

          it 'adds' do
            assert_equal(1, model.visit.insurances.size)
          end
        end

        describe 'meta' do
          let(:model_data) { { 'Meta' => { 'FacilityCode' => '09' } } }

          it 'adds' do
            assert_equal('09', model.meta.facility_code)
          end
        end

        describe 'insurances helper' do
          let(:model_data) { 'bob' }

          describe 'no insurances' do
            it 'returns empty arrray' do
              assert_empty(model.insurances)
            end
          end

          describe 'patient' do
            let(:model_data) { { 'Patient' => { 'Insurances' => ['PolicyNumber' => '0123'] } } }

            it 'uses the patient insurances' do
              assert_equal('0123', model.insurances.first.policy_number)
            end
          end

          describe 'visit' do
            let(:model_data) { { 'Visit' => { 'Insurances' => ['PolicyNumber' => '3210'] } } }

            it 'uses the visit insurances' do
              assert_equal('3210', model.insurances.first.policy_number)
            end
          end

          describe 'patient and visit' do
            let(:model_data) do
              {
                'Patient' => { 'Insurances' => ['PolicyNumber' => '0123'] },
                'Visit' => { 'Insurances' => ['PolicyNumber' => '3210'] }
              }
            end

            it 'concats' do
              assert_equal('0123', model.insurances.first.policy_number)
              assert_equal('3210', model.insurances.last.policy_number)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
