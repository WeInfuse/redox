require 'test_helper'

class Redox::Models::Model < Hashie::Trash
  property :HelloWorld, from: :hello_world
end

class ModelTest < Minitest::Test
  describe 'model' do
    describe 'removes top level key' do
      it 'works for string' do
        z = Redox::Models::Model.new('Model' => {HelloWorld: 50})

        assert_equal(50, z['HelloWorld'])
      end

      it 'works for symbols' do
        z = Redox::Models::Model.new(:Model => {HelloWorld: 50})

        assert_equal(50, z['HelloWorld'])
      end
    end

    it 'ignores undeclared' do
      z = Redox::Models::Model.new({other: 50})

      assert_raises { z[:other] }
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
      y[:HelloWorld] = {i: {j: 20}}
      z[:HelloWorld] = {i: {j: 10}}

      assert_equal(y, z.merge(y))
    end

    it 'can use camel or snake case' do
      y = Redox::Models::Model.new(hello_world: 10)
      z = Redox::Models::Model.new(HelloWorld: 10)

      assert_equal(y, z)
    end

    it 'can methods instead' do
      y = Redox::Models::Model.new()
      z = Redox::Models::Model.new()
      y.hello_world = 10
      z.HelloWorld = 10

      assert_equal(y, z)
    end

    describe '#to_json' do
      it 'adds top level key to hash' do
        z = Redox::Models::Model.new
        z[:HelloWorld] = 10

        assert_equal({'Model' => {HelloWorld: 10}}.to_json, z.to_json)
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
        let(:model_data) { { 'Patient' => {'Demographics' => {'FirstName' => 'Charles'}} } }

        it 'adds' do
          assert_equal('Charles', model.patient.demographics.first_name)
        end
      end

      describe 'meta' do
        let(:model_data) { { 'Meta' => {'FacilityCode' => '09'}} }

        it 'adds' do
          assert_equal('09', model.meta.facility_code)
        end
      end

      describe 'potential matches' do
        let(:model_data) { { 'PotentialMatches' => [ { 'FirstName' => 'bob1'}, { 'FirstName' => 'bob2' }] } }

        it 'adds' do
          assert_equal(2, model.potential_matches.size)
        end
      end
    end
  end
end
