# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'factory_defaults' do
    describe 'build' do
      subject { FactoryBot.build(:image) }

      it 'has image tags attached' do
        expect(subject.tags.size).to eq(2)
      end
    end

    describe 'create' do
      subject { FactoryBot.create(:image) }

      it 'creates image tags' do
        expect { subject }.to change(ImageTag, :count).from(0).to(2)
      end

      it 'creates image' do
        expect { subject }.to change(described_class, :count).from(0).to(1)
      end
    end
  end

  describe 'checks_validity' do
    describe 'canonical_id' do
      subject { FactoryBot.build(:image, canonical_id: canonical_id) }

      let(:canonical_id) { 'valid_canonical_id' }

      context 'with canonical_id' do
        it { is_expected.to be_valid }
      end

      context 'with no canonical_id it should automatically genereate' do
        let(:canonical_id) { nil }

        it { is_expected.to be_valid }
      end
    end

    describe 'name' do
      subject { FactoryBot.build(:image, name: name) }

      let(:name) { 'Sunset' }

      context 'with name' do
        it { is_expected.to be_valid }
      end

      context 'with no name' do
        let(:name) { nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'image file' do
      context 'using active storage' do
        subject { FactoryBot.build(:image).image_file }

        context 'is attached' do
          it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }
        end
      end

      context 'with stubbing file' do
        subject { FactoryBot.build(:image) }

        it { is_expected.to be_valid }
      end

      context 'without stubbing file' do
        subject { FactoryBot.build(:image, :no_image_file) }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'alt text' do
      subject { FactoryBot.build(:image, alt_text: alt_text) }

      let(:alt_text) { nil }

      context 'with no alt text' do
        it { is_expected.to be_valid }
      end
    end

    describe 'image tags' do
      subject { FactoryBot.build(:image, tag_mocks: tag_mocks) }

      let(:tag_mocks) do
        [
          FactoryBot.build(:image_tag),
          FactoryBot.build(:image_tag)
        ]
      end

      context 'with image tags' do
        it { is_expected.to be_valid }
      end

      context 'with no image tags' do
        let(:tag_mocks) { [] }

        it { is_expected.to be_valid }
      end
    end
  end
end
