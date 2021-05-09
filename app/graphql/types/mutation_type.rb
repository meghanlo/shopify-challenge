# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_image_mutation, mutation: Mutations::CreateImageMutation
    field :update_image_mutation, mutation: Mutations::UpdateImageMutation
    field :delete_image_mutation, mutation: Mutations::DeleteImageMutation
    field :delete_many_image_mutation, mutation: Mutations::DeleteManyImageMutation
  end
end
