require 'uuid'

class User < ApplicationRecord
  has_secure_password

  validates :canonical_id, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  before_validation :assign_canonical_id!

  def assign_canonical_id!
    self.canonical_id ||= generate_canonical_id
  end

  def generate_canonical_id
    "user_canonical-#{UUID.generate}"
  end
end
