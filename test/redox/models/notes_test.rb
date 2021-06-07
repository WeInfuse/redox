require 'test_helper'

class NotesTest < Minitest::Test
   describe 'notes' do
      
      let(:notes) { Redox::Models::Notes.new(data) }
      let(:data) { {} }
      let(:deserialized) { JSON.parse(notes.to_json) }

      describe 'Redox::Models::NoteProvider' do
         it 'can be initialized' do
            note_provider = Redox::Models::NoteProvider.new(id: "new_id!")

            assert_equal('new_id!', note_provider.ID)
         end
      end

      describe 'default' do
         it 'has a patient' do
            assert_equal(Redox::Models::Patient, notes.patient.class)
         end

         it 'has a visit' do
            assert_equal(Redox::Models::Visit, notes.visit.class)
         end

         it 'has a note' do
            assert_equal(Redox::Models::Note, notes.note.class)
         end

         it 'has an empty array for appointment_info' do
            assert_equal([], notes.appointment_info)
         end
      end
   end
end