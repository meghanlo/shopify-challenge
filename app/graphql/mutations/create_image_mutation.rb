# frozen_string_literal: true

module Mutations
  class CreateImageMutation < BaseMutation
    argument :name, String, required: true
    argument :image_file, ApolloUploadServer::Upload, required: true
    argument :alt_text, String, required: false
    argument :tags, [String], required: false

    field :image, Types::ImageType, null: true
    field :errors, [Types::Error], null: true

    def resolve(args)
      ActiveRecord::Base.transaction do
        file = args[:image_file]
        args[:image_file] = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: file.original_filename,
          content_type: file.content_type
        )

        record_data = args.slice(:name, :alt_text, :image_file)
        record_data[:user] = context[:current_user]

        image = Image.new(record_data)
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
