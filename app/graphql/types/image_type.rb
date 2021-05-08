# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, ID, 'canonical id of the image', method: :canonical_id, null: false
    field :name, String, null: false
    field :image_url, String, null: false
    field :alt_text, String, null: true
    field :tags, [String], null: true

    def tags
      object.tags.map { |tags| tags[:tag_name] }
    end
  end
end
