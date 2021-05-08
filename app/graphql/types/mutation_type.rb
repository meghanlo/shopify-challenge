# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_image_mutation, mutation: Mutations::CreateImageMutation
    field :update_image_mutation, mutation: Mutations::UpdateImageMutation
  end
end
