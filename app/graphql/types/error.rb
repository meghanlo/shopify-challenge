# frozen_string_literal: true

module Types
  class Error < Types::BaseObject
    field :field, String, null: false
    field :value, String, null: false
  end
end
