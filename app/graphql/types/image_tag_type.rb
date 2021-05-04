# frozen_string_literal: true

module Types
  class ImageTagType < Types::BaseObject
    field :tag_name, String, null: false
  end
end
