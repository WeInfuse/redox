require 'test_helper'

class MediaTest < Minitest::Test
  describe 'media' do
    let(:media) { Redox::Models::Media.new }

    describe '#availablity=' do
      describe 'true' do
        it 'sets to Redox Available' do
          media.availability = true

          assert_equal('Available', media.availability)
        end
      end

      describe 'false' do
        it 'sets to Redox Available' do
          media.availability = false

          assert_equal('Unavailable', media.availability)
        end
      end

      describe 'not boolean' do
        it 'sets to Redox Available' do
          media.availability = :cat

          assert_equal(:cat, media.availability)
        end
      end
    end

    describe '#add_file' do
      describe ' < 200KB file' do
        let(:filepath) { 'test/samples/media.response.json' }

        before do
          media.add_filepath(filepath)
        end

        it 'base64 encodes' do
          assert_equal(Base64.encode64(File.read(filepath)), media[:FileContents])
        end

        it 'adds file extension' do
          assert_equal('JSON', media[:FileType])
        end

        it 'adds file name' do
          assert_equal('media.response', media[:FileName])
        end
      end

      describe ' > 200KB file' do
        let(:filepath) { 'test/samples/bigfile.txt' }

        it 'is not implemented' do
          err = assert_raises(StandardError) { media.add_filepath(filepath) }

          assert_equal('Not implemented', err.message)
        end
      end
    end

    describe 'notifications' do
      it 'can be initialized' do
        m = Redox::Models::Media.new('Notifications' => [{ 'ID' => 'xx', 'IDType' => 'NPI', 'FirstName' => 'John',
                                                           'LastName' => 'Doe', 'Credentials' => ['AS'] }])

        assert_equal('xx', m.Notifications.first['ID'])
        assert_equal('NPI', m.notifications.first['IDType'])
        assert_equal('John', m.notifications.first['FirstName'])
        assert_equal('Doe', m.notifications.first['LastName'])
        assert_equal('AS', m.notifications.first['Credentials'].first)
      end
    end
  end
end
