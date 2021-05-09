require 'jwt'

module Mutations
  class SignInUserMutation < BaseMutation
    null true

    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(credentials: nil)
      return unless credentials

      user = User.find_by email: credentials[:email]

      return unless user
      return unless user.authenticate(credentials[:password])

      exp = Time.now.to_i + 4 * 3600
      payload = {
        id: user.id,
        exp: exp
      }

      token = JWT.encode payload, nil, 'none'
      context[:session][:token] = token

      { user: user, token: token }
    end
  end
end
