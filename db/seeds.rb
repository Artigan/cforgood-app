# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Business.create!({
  name: "Label Terre",
  category: "Bars & Restaurants",
  city: "Bordeaux",
  perk: "Un cookie offert"
})

Business.create!({
  name: "Someone",
  category: "Shopping",
  city: "Bordeaux",
  perk: "15% gratuit"
})
Business.create!({
  name: "Weecolab",
  category: "Tiers Lieux",
  city: "Bordeaux",
  perk: "50% gratuit"
})

User.create!({
  email: "allan.floury@gmail.com",
  admin: true,
  name: "Allan Floury",
  encrypted_password: "joreal85"
  })