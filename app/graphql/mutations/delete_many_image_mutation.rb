# frozen_string_literal: true

module Mutations
  class DeleteManyImageMutation < BaseMutation
    argument :id, [ID], required: true

    field :images, [ID], null: true
    field :errors, [Types::Error], null: true

    def resolve(args)
      ActiveRecord::Base.transaction do
        args[:id]&.each do |canonical_id|
          image = Image.find_by!(canonical_id: canonical_id)
          authorize_allow_owner!(image.user)
          image.tags.destroy_all
          image.image_file.purge
          image.destroy!
        end
      rescue ActiveRecord::RecordInvalid => e
        { errors: e.record.errors.map { |error| { field: error.attribute, value: error.full_message } } }
      else
        { images: args[:id] }
      end
    end
  end
end
