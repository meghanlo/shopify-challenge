require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory_defaults' do
    describe 'create' do
      subject { FactoryBot.create(:user) }

      it 'creates user' do
        expect { subject }.to change(described_class, :count).from(0).to(1)
      end
    end
  end

  describe 'checks_validity' do
    describe 'canonical_id' do
      subject { FactoryBot.build(:user, canonical_id: canonical_id) }

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
      subject { FactoryBot.build(:user, name: name) }

      let(:name) { 'name' }

      context 'with name' do
        it { is_expected.to be_valid }
      end

      context 'with no name' do
        let(:name) { nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'email' do
      subject { FactoryBot.build(:user, email: email) }

      let(:email) { 'example@gmail.com' }

      context 'with email' do
        it { is_expected.to be_valid }
      end

      context 'with no email' do
        let(:email) { nil }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
