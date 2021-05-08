# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    sequence(:name) { |n| "Image-#{n}" }
    sequence(:canonical_id) { |n| "canonical-#{n}" }
    created_at { 2.days.ago }
    updated_at { 1.day.ago }

    transient do
      stub_image_file { true }
      stub_tags { true }
      tag_mocks { nil }
    end

    trait :no_stub_tags do
      stub_tags { false }
    end

    trait :no_image_file do
      stub_image_file { false }
    end

    after(:build) do |instance, evaluator|
      next unless evaluator.stub_image_file

      instance.image_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'photo.jpeg')),
                                 filename: 'photo.jpeg', content_type: 'image/jpeg')

      next unless evaluator.stub_tags

      if evaluator.tag_mocks.nil?
        instance.tags = build_list(:image_tag, 2, image: instance)
        tag_mocks = instance.tags.map(&:tag_name).map do |tag_name|
          FactoryBot.build(:image_tag, tag_name: tag_name)
        end.compact
      else
        tag_mocks = evaluator.tags
        instance.tags = evaluator.tag_mocks.map(&:tag_name).map do |tag_name|
          FactoryBot.build(:image_tag, tag_name: tag_name, image: instance)
        end
      end
    end
  end
end
