# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Mutations::DeleteImageMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }, headers: { 'HTTP_AUTHORIZATION' => mock_header }
  end

  let(:image) do
    FactoryBot.create(:image, name: 'image1', alt_text: 'alt_Text')
  end

  let(:mock_header) do
    mock_header_request(image.user)
  end

  let(:query) do
    <<-GRAPHQL
      mutation deleteImageMutation($input: DeleteImageMutationInput!) {
        deleteImageMutation(input: $input) {
          image
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
    let(:variables) do
      {
        input: {
          id: image.canonical_id
        }
      }
    end

    let(:expected_output) do
      {
        image: variables[:input][:id]
      }
    end

    it 'returns no errors' do
      go!
      expect(response_json[:data][:deleteImageMutation][:errors]).to be_nil
    end

    it 'returns JSON' do
      go!
      expect(response_json[:data][:deleteImageMutation]).to include(expected_output)
    end

    it 'does delete the image ' do
      expect { go! }.to change(Image, :count).from(1).to(0)
    end

    it 'does delete image tags' do
      expect { go! }.to change(ImageTag, :count).from(2).to(0)
    end
  end

  context 'with invalid params' do
    context 'without image id' do
      let(:variables) do
        {
          input: {
            name: 'updated input name'
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
            id: image.canonical_id
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
