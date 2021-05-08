# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :image, Types::ImageType, null: false, description: 'Find image by image canonical id', null: true do
      argument :id, String, required: true
    end

    field :images, [Types::ImageType], null: false, description: 'Find images by name or tags', null: true do
      argument :name, String, required: false
      argument :tags, [String], required: false
    end

    def image(id:)
      Image.find_by!(canonical_id: id)
    end

    def images(args = {})
      if args[:name].present? & args[:tags].present?
        raise GraphQL::ExecutionError,
              'Must specify exactly one of name or tags'
      end

      images = if args[:name]
                 Image.where(args.slice(:name))
               elsif args[:tags]
                 Image.joins(:tags).where(tags: { tag_name: args[:tags] }).distinct
               else
                 Image.all
               end

      raise ActiveRecord::RecordNotFound if images.empty?

      images
    end
  end
end
