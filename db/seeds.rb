# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(
  name: 'Meghan Lo',
  email: 'example@email.com',
  password: 'SecurePassword'
)

user2 = User.create!(
  name: 'Luke Skywalker',
  email: 'jedi@email.com',
  password: 'TheseAreNotTheDroidsYoureLookingFor'
)

sunset_image = Image.new(
  user: user1,
  name: 'sunset',
  alt_text: 'toronto skyline during sunset',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)

sunset_image.image_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'photo.jpeg')),
                               filename: 'photo.jpeg', content_type: 'image/jpeg')
sunset_image.tags << ImageTag.create!(image: sunset_image, tag_name: 'landscape', created_at: 2.days.ago,
                                      updated_at: 2.days.ago)
sunset_image.tags << ImageTag.create!(image: sunset_image, tag_name: 'orange', created_at: 2.days.ago,
                                      updated_at: 2.days.ago)
sunset_image.save!

ocean_image = Image.new(
  user: user1,
  name: 'ocean',
  created_at: 2.days.ago,
  updated_at: 2.days.ago
)
ocean_image.image_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'photo2.jpeg')),
                              filename: 'photo2.jpeg', content_type: 'image/jpeg')
ocean_image.tags << ImageTag.create!(image: ocean_image, tag_name: 'landscape', created_at: 2.days.ago,
                                     updated_at: 2.days.ago)
ocean_image.tags << ImageTag.create!(image: ocean_image, tag_name: 'blue', created_at: 2.days.ago,
                                     updated_at: 2.days.ago)
ocean_image.tags << ImageTag.create!(image: ocean_image, tag_name: 'water', created_at: 1.days.ago,
                                     updated_at: 2.days.ago)
ocean_image.save!

baby_yoda = Image.new(
  user: user2,
  name: 'Baby Yoda - Star Wars',
  alt_text: 'Grogu holding a cup',
  created_at: 10.days.ago,
  updated_at: 2.days.ago
)
baby_yoda.image_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'photo3.jpeg')),
                            filename: 'photo3.jpeg', content_type: 'image/jpeg')
baby_yoda.tags << ImageTag.create!(image: ocean_image, tag_name: 'star wars', created_at: 3.days.ago,
                                   updated_at: 2.days.ago)
baby_yoda.tags << ImageTag.create!(image: ocean_image, tag_name: 'yoda', created_at: 24.days.ago,
                                   updated_at: 5.days.ago)
baby_yoda.tags << ImageTag.create!(image: ocean_image, tag_name: 'cute', created_at: 5.days.ago,
                                   updated_at: 3.days.ago)
baby_yoda.save!
