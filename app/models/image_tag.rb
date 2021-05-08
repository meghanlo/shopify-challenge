class ImageTag < ApplicationRecord
    validates :image, presence: true
    validates :tag_name, presence: true

    belongs_to :image, foreign_key: :image_id, inverse_of: :tags
end
