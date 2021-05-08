# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Mutations::CreateImageMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }
  end

  let(:imageFile) do
    Rack::Test::UploadedFile.new(Rails.root.join(file_fixture('photo.jpeg')), 'image/jpeg')
  end

  let(:imageUrl) do
    rails_blob_path(imageFile, only_path: true)
  end

  let(:query) do
    <<-GRAPHQL
      mutation createImageMutation($input: CreateImageMutationInput!) {
        createImageMutation(input: $input) {
          image {
            id
            name
            altText
            imageUrl
            tags
          }
          errors {
            field
            value
          }
        }
      }
    GRAPHQL
  end

  context 'with valid input' do
    let(:variables) do
      {
        input: {
          name: 'Image Name',
          tags: ['test tag 1', 'image tag'],
          imageFile: imageFile
        }
      }
    end

    let(:expected_output) do
      {
        id: be_present,
        name: variables[:input][:name],
        imageUrl: be_present,
        altText: variables[:input][:altText],
        tags: variables[:input][:tags]
      }
    end

    it 'returns no errors' do
      go!
      expect(response_json[:errors]).to be_nil
    end

    it 'returns JSON' do
      go!
      expect(response_json[:data][:createImageMutation][:image]).to include(expected_output)
    end

    it 'creates the image ' do
      expect { go! }.to change(Image, :count).from(0).to(1)
    end

    it 'creates the image tags' do
      expect { go! }.to change(ImageTag, :count).from(0).to(2)
    end
  end

  context 'with invalid params' do
    context 'without name' do
      let(:variables) do
        {
          input: {
            tags: ['test tag 1', 'image tag'],
            imageFile: imageFile
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the image ' do
        expect { go! }.not_to change(Image, :count)
      end

      it 'does not creates the image tags' do
        expect { go! }.not_to change(ImageTag, :count)
      end
    end

    context 'without image file' do
      let(:variables) do
        {
          input: {
            name: 'Image Name',
            tags: ['test tag 1', 'image tag']
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the image ' do
        expect { go! }.not_to change(Image, :count)
      end

      it 'does not creates the image tags' do
        expect { go! }.not_to change(ImageTag, :count)
      end
    end
  end
end
