# frozen_string_literal: true

class Image < ApplicationRecord
  validates :name, presence: true
  validates :canonical_id, presence: true
  validates :image_url, presence: true

  has_many :tags, class_name: 'ImageTag', inverse_of: :image, dependent: :restrict_with_exception

  before_validation :assign_canonical_id!

  def assign_canonical_id!
    self.canonical_id ||= generate_canonical_id
  end

  def generate_canonical_id
    "image_canonical-#{UUID.generate}"
  end
end
