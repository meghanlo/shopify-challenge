# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sunset_image = Image.create!(
  name: 'sunset',
  image_url: './sunset_image.jpg',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ImageTag.create!(
  image_id: sunset_image,
  tag_name: 'landscape',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ImageTag.create!(
  image_id: sunset_image,
  tag_name: 'orange',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ocean_image = Image.create!(
  name: 'beach',
  image_url: './ocean_image.jpg',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ImageTag.create!(
  image_id: sunset_image,
  tag_name: 'landscape',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ImageTag.create!(
  image_id: sunset_image,
  tag_name: 'blue',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

ImageTag.create!(
  image_id: sunset_image,
  tag_name: 'water',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)
