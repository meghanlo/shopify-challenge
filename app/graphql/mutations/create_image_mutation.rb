module Mutations
  class CreateImageMutation < BaseMutation
    argument :name, String, required: true
    argument :image_url, String, required: true
    argument :alt_text, String, required: false
    argument :tags, [String], required: false

    field :image, Types::ImageType, null: true
    field :errors, [Types::Error], null: true

    def resolve(args)
      ActiveRecord::Base.transaction do
        image = Image.new(args.slice(:name, :image_url, :alt_text))
        args[:tags]&.each do |tag|
          image.tags << ImageTag.new(image: image, tag_name: tag)
        end
        image.save!

      rescue ActiveRecord::RecordInvalid => e
        { errors: e.record.errors.map { |error| { field: error.attribute, value: error.full_message } } }
      else
        { image: image }
      end
    end
  end
end
