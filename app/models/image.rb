# frozen_string_literal: true

require 'uuid'
include(Rails.application.routes.url_helpers)

class Image < ApplicationRecord
  validates :name, presence: true
  validates :canonical_id, presence: true

  belongs_to :user
  has_many :tags, class_name: 'ImageTag', inverse_of: :image, dependent: :restrict_with_exception

  has_one_attached :image_file, dependent: :destroy

  before_validation :assign_canonical_id!

  validate :check_file_presence!

  def assign_canonical_id!
    self.canonical_id ||= generate_canonical_id
  end

  def generate_canonical_id
    "image_canonical-#{UUID.generate}"
  end

  def check_file_presence!
    errors.add(:image_file, 'no file added') unless image_file.attached?
  end
end
