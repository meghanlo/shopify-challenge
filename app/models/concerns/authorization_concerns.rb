module AuthorizationConcerns
  extend ActiveSupport::Concern

  def authorize_allow_owner!(owner)
    access = context[:current_user]

    raise GraphQL::ExecutionError, 'Only the owner of the image can make changes' unless access == owner
  end
end
