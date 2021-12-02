require 'test_helper'

class NoteTest < Minitest::Test
  describe 'note' do
    let(:note) { Redox::Models::Note.new(data) }
    let(:data) { {} }
    let(:deserialized) { JSON.parse(note.to_json) }

    describe 'default' do

      it 'has provider' do
        assert_equal({}, note.provider)
      end

      it 'has an empty array for components' do
        assert_equal([], note.components)
      end
    end

    describe 'to_json' do
      describe 'with a component' do
        let(:components) { Redox::Models::Component.new({id: nil, name: 'name', value: 'value'}) }

        before do
          note.components << components
        end

        it 'serializes correctly' do
          assert_equal(Array, deserialized.dig('Components').class)
          assert_equal(true, deserialized.dig('Components').first.include?('ID'))
          assert_equal(true, deserialized.dig('Components').first.include?('Name'))
          assert_equal(true, deserialized.dig('Components').first.include?('Value'))
        end
      end

      describe 'with a provider' do
        let(:provider) { {
          FirstName: 'first_name',
          LastName: 'last_name',
          IDType: 'NPI',
          ID: '123123'
        } }

        before do
          note.provider = provider
        end

        it 'serializes correctly' do
          assert_equal(Hash, deserialized.dig('Provider').class)
          assert_equal(true, deserialized.dig('Provider').include?('FirstName'))
          assert_equal(true, deserialized.dig('Provider').include?('LastName'))
          assert_equal(true, deserialized.dig('Provider').include?('IDType'))
          assert_equal(true, deserialized.dig('Provider').include?('ID'))
        end
      end
    end
  end
end
