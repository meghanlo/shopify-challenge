# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, ID, 'canonical id of the image', method: :canonical_id, null: false
    field :name, String, null: false
    field :image_url, String, null: false
    field :alt_text, String, null: true
    field :image_url, String, null: false
    field :user, UserType, null: true
    field :tags, [String], null: true

    def image_url
      rails_blob_path(object.image_file, only_path: true) if object.image_file.present?
    end

    def tags
      object.tags.map { |tags| tags[:tag_name] }
    end
  end
end
