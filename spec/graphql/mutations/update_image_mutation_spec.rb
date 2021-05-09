# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Mutations::UpdateImageMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }, headers: { 'HTTP_AUTHORIZATION' => mock_header }
  end

  let(:image) do
    FactoryBot.create(:image, name: 'original name', alt_text: 'orignal alternative text')
  end

  let(:mock_header) do
    mock_header_request(image.user)
  end

  let(:query) do
    <<-GRAPHQL
      mutation updateImageMutation($input: UpdateImageMutationInput!) {
        updateImageMutation(input: $input) {
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

  before do
    image.save!
  end

  context 'with valid input' do
    context 'with name and alt_text' do
      let(:variables) do
        {
          input: {
            id: image.canonical_id,
            name: 'updated input name',
            altText: nil
          }
        }
      end

      let(:expected_output) do
        {
          id: be_present,
          name: variables[:input][:name],
          imageUrl: be_present,
          altText: variables[:input][:alt_text],
          tags: [image.tags[0].tag_name, image.tags[1].tag_name]
        }
      end

      it 'returns no errors' do
        go!
        expect(response_json[:data][:updateImageMutation][:errors]).to be_nil
      end

      it 'returns JSON' do
        go!
        expect(response_json[:data][:updateImageMutation][:image]).to include(expected_output)
      end

      it 'does not create an image ' do
        expect { go! }.not_to change(Image, :count)
      end

      it 'does not create image tags' do
        expect { go! }.not_to change(ImageTag, :count)
      end
    end

    context 'with image tags' do
      context 'with new image tag' do
        let(:variables) do
          {
            input: {
              id: image.canonical_id,
              tags: [image.tags[0].tag_name, image.tags[1].tag_name, 'new tag name']
            }
          }
        end

        let(:expected_output) do
          {
            id: be_present,
            name: image.name,
            imageUrl: be_present,
            altText: image.alt_text,
            tags: variables[:input][:tags]
          }
        end

        it 'returns no errors' do
          go!
          expect(response_json[:data][:updateImageMutation][:errors]).to be_nil
        end

        it 'returns JSON' do
          go!
          expect(response_json[:data][:updateImageMutation][:image]).to include(expected_output)
        end

        it 'does not create an image ' do
          expect { go! }.not_to change(Image, :count)
        end

        it 'does creates the new image tags' do
          expect { go! }.to change(ImageTag, :count).from(2).to(3)
        end
      end

      context 'with removing image tag' do
        let(:variables) do
          {
            input: {
              id: image.canonical_id,
              tags: [nil]
            }
          }
        end

        let(:expected_output) do
          {
            id: be_present,
            name: image.name,
            imageUrl: be_present,
            altText: image.alt_text,
            tags: []
          }
        end

        it 'returns no errors' do
          go!
          expect(response_json[:data][:updateImageMutation][:errors]).to be_nil
        end

        it 'returns JSON' do
          go!
          expect(response_json[:data][:updateImageMutation][:image]).to include(expected_output)
        end

        it 'does not create an image ' do
          expect { go! }.not_to change(Image, :count)
        end

        it 'does delete existing image tags' do
          expect { go! }.to change(ImageTag, :count).from(2).to(0)
        end
      end
    end
  end

  context 'with invalid params' do
    context 'without image id' do
      let(:variables) do
        {
          input: {
            name: 'updated input name',
            altText: nil
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

    context 'without proper authorization' do
      let(:non_owner_user) { FactoryBot.create(:user) }

      let(:mock_header) do
        mock_header_request(non_owner_user)
      end

      let(:variables) do
        {
          input: {
            id: image.canonical_id,
            name: 'updated input name',
            altText: nil
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
