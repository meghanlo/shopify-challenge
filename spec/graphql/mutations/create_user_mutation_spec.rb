RSpec.describe Mutations::CreateUserMutation, type: :request do
  def go!
    post '/graphql', params: { query: query, variables: variables }
  end

  let(:query) do
    <<-GRAPHQL
      mutation createUserMutation($input: CreateUserMutationInput!) {
        createUserMutation(input: $input) {
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
          name: 'Test user',
          authProvider: {
            credentials: {
              email: 'email@example.com',
              password: '[omitted]'
            }
          }
        }
      }
    end

    let(:expected_output) do
      {
        name: variables[:input][:name],
        email: variables[:input][:authProvider][:credentials][:email]
      }
    end

    it 'returns no errors' do
      go!
      expect(response_json[:errors]).to be_nil
    end

    it 'returns JSON' do
      go!
      expect(response_json[:data][:createUserMutation][:user]).to include(expected_output)
    end

    it 'creates the image ' do
      expect { go! }.to change(User, :count).from(0).to(1)
    end
  end

  context 'with invalid params' do
    context 'without name' do
      let(:variables) do
        {
          input: {
            authProvider: {
              credentials: {
                email: 'email@example.com',
                password: '[omitted]'
              }
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the user ' do
        expect { go! }.not_to change(User, :count)
      end
    end

    context 'without email' do
      let(:variables) do
        {
          input: {
            authProvider: {
              name: 'Test user',
              credentials: {
                password: '[omitted]'
              }
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the sser ' do
        expect { go! }.not_to change(User, :count)
      end
    end

    context 'without password' do
      let(:variables) do
        {
          input: {
            authProvider: {
              name: 'Test user',
              credentials: {
                email: 'email@example.com'
              }
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the sser ' do
        expect { go! }.not_to change(User, :count)
      end
    end

    context 'without existing user' do
      let(:existing_user) { FactoryBot.build(:user, name: 'exising name', email: 'existing email') }

      let(:variables) do
        {
          iinput: {
            authProvider: {
              name: 'new name',
              credentials: {
                email: existing_user.email,
                password: '[omitted]'
              }
            }
          }
        }
      end

      it 'returns errors' do
        go!
        expect(response_json[:errors]).to be_truthy
      end

      it 'does not creates the sser ' do
        expect { go! }.not_to change(User, :count)
      end
    end
  end
end
