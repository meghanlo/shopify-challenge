require 'securerandom'

class UUID
  def self.generate(max_length = 10)
    uuid = SecureRandom.urlsafe_base64(max_length)
    uuid.delete('-')
  end
end