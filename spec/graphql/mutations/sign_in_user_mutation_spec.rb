RSpec.describe Mutations::SignInUserMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }
  end

  let(:existing_user) do
    FactoryBot.create(:user, name: 'exising name', email: 'email@example.com', password: 'omitted')
  end

  let(:query) do
    <<-GRAPHQL
      mutation signInUserMutation($input: SignInUserMutationInput!) {
        signInUserMutation(input: $input) {
          token
          user {
            name
            email
          }
        }
      }
    GRAPHQL
  end

  context 'with valid input' do
    let(:variables) do
      {
        input: {
          credentials: {
            email: existing_user.email,
            password: existing_user.password
          }
        }
      }
    end

    let(:expected_output) do
      {
        token: be_present,
        user: {
          name: existing_user.name,
          email: variables[:input][:credentials][:email]
        }
      }
    end

    it 'returns no errors' do
      go!
      expect(response_json[:errors]).to be_nil
    end
  end

  context 'with invalid params' do
    context 'without email' do
      let(:variables) do
        {
          input: {
            credentials: {
              password: existing_user.password
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end
    end

    context 'without password' do
      let(:variables) do
        {
          input: {
            credentials: {
              email: existing_user.email
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end
    end

    context 'with email that does not exist' do
      let(:variables) do
        {
          input: {
            credentials: {
              email: 'fake email',
              password: existing_user.password
            }
          }
        }
      end

      it 'does not return anything' do
        go!
        expect(response_json[:data][:signInUserMutation]).to eq(nil)
      end
    end

    context 'with wrong password' do
      let(:variables) do
        {
          input: {
            credentials: {
              email: existing_user.email,
              password: 'wrong password'
            }
          }
        }
      end

      it 'does not return anything' do
        go!
        expect(response_json[:data][:signInUserMutation]).to eq(nil)
      end
    end
  end
end
