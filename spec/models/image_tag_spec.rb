require 'rails_helper'

RSpec.describe ImageTag, type: :model do
  let(:image) do
    FactoryBot.build(:image, :no_stub_tags)
  end

  describe 'checks_validity' do
    subject { FactoryBot.build(:image_tag, image: image) }

    describe 'image' do

      context 'with image' do
        it { is_expected.to be_valid}
      end

      context 'with no image' do
        let (:image) {nil}

        it 'is not valid' do
          expect(subject.valid?).to be false
          expect(subject.errors.full_messages).to eq ["Image can't be blank", "Image must exist"]
        end
      end
    end

    describe 'image tag' do
      subject { FactoryBot.build(:image_tag, image: image, tag_name: tag_name) }

      let(:tag_name) { "Landscape" }

      context 'with tag name' do
        it { is_expected.to be_valid}
      end

      context 'with no tag name' do
        let (:tag_name) { nil }

        it { is_expected.not_to be_valid}
      end
    end
  end
end
