FactoryBot.define do
  factory :image_tag do
    sequence(:tag_name) {|n| "tag-#{n}"}
  end
end
