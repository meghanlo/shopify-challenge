module Types
  class UserType < Types::BaseObject
    field :id, ID, 'canonical id of the user', method: :canonical_id, null: false
    field :name, String, null: false
    field :email, String, null: false
  end
end
