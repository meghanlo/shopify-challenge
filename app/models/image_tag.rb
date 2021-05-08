# frozen_string_literal: true

class ImageTag < ApplicationRecord
  validates :image, presence: true
  validates :tag_name, presence: true

  belongs_to :image, inverse_of: :tags
end
