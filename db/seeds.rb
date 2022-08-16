# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

100.times do
  User.create(
    name: Faker::Name.first_name,
    nickname: Faker::Nation.unique.nationality, # не нашел ник
    password_digest: 1,
    email: Faker::Internet.email
  )
end

100.times do
  Question.create(
    body: Faker::Lorem.question,
    user_id: rand(1..User.all.count),
    answer: rand(0..4).zero? ? 'yes' : nil,
    author_id: rand(0..2).zero? ? User.order('RANDOM()').first.id : nil #Model.order('RANDOM()').first
  )
end
