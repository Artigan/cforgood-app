# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# BusinessCategory.destroy_all
Business.destroy_all

# bar = BusinessCategory.create!({
#   name: "Bars & Restaurants"
#   })

# shop = BusinessCategory.create!({
#   name: "Shopping"
#   })

# tiers = BusinessCategory.create!({
#   name: "Tiers Lieux"
#   })

Business.create!({
  name: "Label Terre",
  email: "label@terre.com",
  business_category_id: 20,
  city: "Bordeaux"
  # perk: "Un cookie offert"
})

Business.create!({
  name: "Someone",
  email: "someone@gmail.com",
  business_category_id: 21,
  city: "Bordeaux"
  # perk: "15% gratuit"
})
Business.create!({
  name: "Weecolab",
  email: "weecolab@gmail.fr",
  business_category_id: 22,
  city: "Bordeaux"
  # perk: "50% gratuit"
})



