# frozen_string_literal: true

Rails.application.routes.draw do
  # namespace :api, defaults: { format: json } do
  # end
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: 'graphql#execute' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'
end
