require 'test_helper'

class MediaUploadTest < Minitest::Test
  describe 'media_upload' do
    let(:media_upload) { Redox::Models::MediaUpload.new(data) }
    let(:data) { {} }
    describe 'default' do
      it 'has a patient' do
        assert_equal(Redox::Models::Patient, media_upload.patient.class)
      end

      it 'has a media' do
        assert_equal(Redox::Models::Media, media_upload.media.class)
      end

      it 'has a visit' do
        assert_equal(Redox::Models::Visit, media_upload.visit.class)
      end
    end

    describe 'media' do
      it 'can be initialized' do
        media_upload = Redox::Models::MediaUpload.new('Media' => {'FileName' => 'test.pdf'})

        assert_equal('test.pdf', media_upload.media['FileName'])
      end

      it 'can be built' do
        media_upload = Redox::Models::MediaUpload.new

        media_upload.media['FileName'] = 'test.jpg'
        assert_equal('test.jpg', media_upload.media['FileName'])
      end
    end
  end
end
