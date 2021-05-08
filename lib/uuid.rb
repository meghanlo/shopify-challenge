# frozen_string_literal: true

require 'securerandom'

class UUID
  def self.generate(max_length = 10)
    uuid = SecureRandom.urlsafe_base64(max_length)
    uuid.delete('-')
    uuid.delete('_')
  end
end
