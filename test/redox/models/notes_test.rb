require 'test_helper'

class NotesTest < Minitest::Test
  describe 'notes' do
    let(:notes) { Redox::Models::Notes.new(data) }
    let(:data) { {} }
    let(:deserialized) { JSON.parse(notes.to_json) }

    describe 'Note subsection' do
      it 'can be initialized' do
        notes = Redox::Models::Notes.new('Note' => { 'ContentType' => 'Base64 Encoded' })

        assert_equal('Base64 Encoded', notes.Note['ContentType'])
      end

      it 'can be built' do
        notes = Redox::Models::Notes.new(
          'Note' => { 'ContentType' => 'Base64 Encoded', 'DocumentType' => 'Empty File',
                      'DocumentID' => 'b169267c' }, 'Meta' => { 'DataModel' => 'Notes' }
        )

        notes.note.content_type = 'Bob'

        assert_equal('Bob', notes.Note['ContentType'])
        assert_equal('Notes', notes.Meta['DataModel'])
      end

      describe 'Provider subsection of Notes subsection' do
        it 'can be initialized' do
          notes = Redox::Models::Notes.new('Note' => { 'ContentType' => 'Base64 Encoded',
                                                       'DocumentType' => 'Empty File', 'DocumentID' => 'b169267c', 'Provider' => { 'ID' => '123' } })

          assert_equal('123', notes.note.Provider['ID'])
        end

        it 'can be built' do
          notes = Redox::Models::Notes.new('Note' => { 'ContentType' => 'Base64 Encoded',
                                                       'DocumentType' => 'Empty File', 'DocumentID' => 'b169267c', 'Provider' => { 'ID' => '123' } })

          notes.note.provider = { 'ID' => 'Bob' }

          assert_equal('Bob', notes.Note['Provider']['ID'])
        end
      end
    end

    describe 'default' do
      it 'has a note' do
        assert_instance_of(Redox::Models::Note, notes.note)
      end

      it 'has a notes' do
        assert_instance_of(Redox::Models::Notes, notes)
      end
    end
  end
end
