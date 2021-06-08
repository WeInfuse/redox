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

      describe 'Provider subsection' do
         it 'can be initialized' do
            notes = Redox::Models::Notes.new('Note' => {'ContentType' => 'Base64 Encoded', 'DocumentType' => 'Empty File', 'DocumentID' => 'b169267c', 'Provider' => {'ID' => '123'}})

            assert_equal('123', notes.note.Provider['ID'])
         end

         it 'can be built' do
            notes = Redox::Models::Notes.new('Note' => {'ContentType' => 'Base64 Encoded', 'DocumentType' => 'Empty File', 'DocumentID' => 'b169267c', 'Provider' => {'ID' => '123'}})

            notes.note.provider = {'ID' => "Bob"}
            assert_equal('Bob', notes.Note['Provider']['ID'])
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