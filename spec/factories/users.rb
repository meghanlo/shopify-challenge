FactoryBot.define do
  factory :user do
    name { |n| "name-#{n}" }
    canonical_id { |n| "canonical_id-#{n}" }
    email { |n| "email#{n}@gmail.com" }
    password_digest { |n| "password-#{n}" }
  end
end
