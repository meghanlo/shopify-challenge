class Image < ApplicationRecord
    validates :name, presence: true
    validates :image_url, presence: true

    has_many :tags, class_name: 'ImageTag', foreign_key: :image_id, inverse_of: :image, dependent: :restrict_with_exception
end
