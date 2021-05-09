# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Mutations::DeleteManyImageMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }
  end

  let(:image1) do
    FactoryBot.create(:image, name: 'image1', alt_text: 'alt_Text')
  end
  let(:image2) do
    FactoryBot.create(:image, :no_stub_tags, name: 'image1')
  end

  let(:query) do
    <<-GRAPHQL
      mutation deleteImageMutation($input: DeleteManyImageMutationInput!) {
        deleteManyImageMutation(input: $input) {
          images
          errors {
            field
            value
          }
        }
      }
    GRAPHQL
  end

  before do
    image1.save!
    image2.save!
  end

  context 'with valid input' do
    let(:variables) do
      {
        input: {
          id: [image1.canonical_id, image2.canonical_id]
        }
      }
    end

    let(:expected_output) do
      {
        images: variables[:input][:id]
      }
    end

    it 'returns no errors' do
      go!
      expect(response_json[:data][:deleteManyImageMutation][:errors]).to be_nil
    end

    it 'returns JSON' do
      go!
      expect(response_json[:data][:deleteManyImageMutation]).to include(expected_output)
    end

    it 'does delete the images ' do
      expect { go! }.to change(Image, :count).from(2).to(0)
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
  end
end
