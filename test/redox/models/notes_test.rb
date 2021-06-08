require 'test_helper'

class NotesTest < Minitest::Test
   describe 'notes' do
      let(:notes) { Redox::Models::Notes.new(data) }
      let(:data) { {} }
      let(:deserialized) { JSON.parse(notes.to_json) }

      describe 'Note subsection' do
         it 'can be initialized' do
            notes = Redox::Models::Notes.new('Note' => {'ContentType' => 'Base64 Encoded'})

            assert_equal('Base64 Encoded', notes.Note['ContentType'])
         end

         it 'can be built' do
            notes = Redox::Models::Notes.new('Note' => {'ContentType' => 'Base64 Encoded', 'DocumentType' => 'Empty File', 'DocumentID' => 'b169267c'})

            notes.note.content_type = 'Bob'
            assert_equal('Bob', notes.Note['ContentType'])
         end
      end

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

         it 'has a notes' do
            assert_equal(Redox::Models::Notes, notes.class)
         end
      end
   end
end