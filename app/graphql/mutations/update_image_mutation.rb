# frozen_string_literal: true

module Mutations
  class UpdateImageMutation < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :alt_text, String, required: false
    argument :tags, [String], required: false

    field :image, Types::ImageType, null: true
    field :errors, [Types::Error], null: true

    def resolve(args)
      ActiveRecord::Base.transaction do
        image = Image.find_by!(canonical_id: args[:id])
        authorize_allow_owner!(image.user)
        image.update!(args.slice(:name, :alt_text))

        if args[:tags]
          image.tags.where.not(tag_name: args[:tags]).destroy_all

          (args[:tags] - image.tags.pluck(:tag_name))&.each do |tag|
            ImageTag.create!(image: image, tag_name: tag)
          end
        end

      rescue ActiveRecord::RecordInvalid => e
        { errors: e.record.errors.map { |error| { field: error.attribute, value: error.full_message } } }
      else
        { image: image }
      end
    end
  end
end
