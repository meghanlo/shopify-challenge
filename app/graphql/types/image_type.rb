# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :image_url, String, null: false
    field :canonical_id, String, null: false
    field :name, String, null: false
    field :alt_text, String, null: true
    field :tags, [Types::ImageTagType], null: true
  end
end
