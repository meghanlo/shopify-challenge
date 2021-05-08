# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Types::ImageType, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }
  end

  let!(:image1) { FactoryBot.create(:image, tag_mocks: tag_mocks) }
  let!(:image2) { FactoryBot.create(:image, tag_mocks: tag_mocks) }
  let!(:tag_mocks) do
    [
      FactoryBot.build(:image_tag)
    ]
  end

  context 'by image id' do
    let(:query) do
      <<-GRAPHQL
      query($id: ID!) {
        image(id: $id) {
          id
          name
          altText
          imageUrl
          tags
        }#{' '}
      }
      GRAPHQL
    end

    let(:expected_output) do
      {
        id: image1.canonical_id,
        name: image1.name,
        imageUrl: rails_blob_path(image1.image_file, only_path: true),
        altText: image1.alt_text,
        tags: [tag_mocks[0].tag_name]
      }
    end

    let(:variables) do
      {
        id: id
      }
    end

    context 'with valid params' do
      let(:id) { image1.canonical_id }

      it 'returns no error' do
        go!
        expect(response_json[:errors]).to eq(nil)
      end

      it 'returns JSON' do
        go!
        expect(response_json[:data][:image]).to include(expected_output)
      end

      it 'returns the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end

    context 'with missing image' do
      let(:id) { 'not a real id' }

      it 'raises error' do
        expect { go! }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'with invalid params' do
      let(:id) { nil }

      it 'raises error' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not create the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end
  end

  context 'by image name' do
    let(:query) do
      <<-GRAPHQL
      query($name: String!) {
        images(name: $name) {
          id
          name
          altText
          imageUrl
          tags
        }
      }
      GRAPHQL
    end

    let(:expected_output) do
      {
        id: image1.canonical_id,
        name: image1.name,
        altText: image1.alt_text,
        imageUrl: rails_blob_path(image1.image_file, only_path: true),
        tags: [tag_mocks[0].tag_name]
      }
    end

    let(:variables) do
      {
        name: name_var
      }
    end

    context 'with valid params' do
      let(:name_var) { image1.name }

      it 'returns no error' do
        go!
        expect(response_json[:errors]).to eq(nil)
      end

      it 'returns JSON' do
        go!
        expect(response_json[:data][:images]).to include(expected_output)
      end

      it 'returns the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end

    context 'with missing image' do
      let(:name_var) { 'not a real name' }

      it 'raises error' do
        expect { go! }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'with invalid params' do
      let!(:name_var) { nil }

      it 'raises error' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not create the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end
  end

  context 'by image tags' do
    let(:query) do
      <<-GRAPHQL
      query($tags: [String!]!) {
        images(tags: $tags) {
          id
          name
          altText
          imageUrl
          tags
        }
      }
      GRAPHQL
    end

    let(:expected_output) do
      [{
        id: image1.canonical_id,
        name: image1.name,
        altText: image1.alt_text,
        imageUrl: rails_blob_path(image1.image_file, only_path: true),
        tags: [tag_mocks[0].tag_name]
      },
       {
         id: image2.canonical_id,
         name: image2.name,
         altText: image2.alt_text,
         imageUrl: rails_blob_path(image2.image_file, only_path: true),
         tags: [tag_mocks[0].tag_name]
       }]
    end

    let(:variables) do
      {
        tags: tags
      }
    end

    context 'with valid params' do
      let(:tags) { [tag_mocks[0].tag_name] }

      it 'returns no error' do
        go!
        expect(response_json[:errors]).to eq(nil)
      end

      it 'returns JSON' do
        go!
        expect(response_json[:data][:images]).to include(expected_output[0])
      end

      it 'returns the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end

    context 'with missing image tag' do
      let(:tags) { ['not a real tag'] }

      it 'raises error' do
        expect { go! }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'with invalid params' do
      let(:tags) { nil }

      it 'raises error' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not create the image' do
        expect { go! }.not_to change(Image, :count)
      end
    end
  end
end
