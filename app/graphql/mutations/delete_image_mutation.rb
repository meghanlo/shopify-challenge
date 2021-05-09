# frozen_string_literal: true

module Mutations
  class DeleteImageMutation < BaseMutation
    argument :id, ID, required: true

    field :image, ID, null: true
    field :errors, [Types::Error], null: true

    def resolve(args)
      ActiveRecord::Base.transaction do
        image = Image.find_by!(canonical_id: args[:id])
        image.tags.destroy_all
        image.image_file.purge
        image.destroy!
      rescue ActiveRecord::RecordInvalid => e
        { errors: e.record.errors.map { |error| { field: error.attribute, value: error.full_message } } }
      else
        { image: args[:id] }
      end
    end
  end
end
