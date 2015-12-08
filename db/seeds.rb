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

b = Business.create({
  name: "Label Terre",
  email: "labelterre@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"2 cours alsace lorraine",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.create({
  perk: "Un cookie offert",
  description: "Cool",
  permanent: true,
  active: true
})

b = Business.create({
  name: "Weecolab",
  email: "weecolab@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"30 rue pomme d'or",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "50% offert",
  description: "Pour les 3 premiers mois",
  permanent: true,
  active: true
})

b = Business.create({
  name: "Ex Aequo",
  email: "exaequo@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"2 place camille julian",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "15% offert",
  description: "Pour toi !",
  permanent: true,
  active: true
})

b = Business.create({
  name: "Do you speack français ?",
  email: "dysf@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"30 rue notre dame",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "Un t-shit offert",
  description: "Top !",
  permanent: true,
  active: true
})

b = Business.create!({
  name: "Mon potager city",
  email: "monpotagercity@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"10 rue david johnston",
  zipcode:"33000",
  city: "Bordeaux",
})
b.perks.build!({
  perk: "Un panier offert",
  description: "Incroyable !",
  permanent: true,
  active: true
})

b = Business.create({
  name: "Décalez",
  email: "decalez@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"15 rue de la rousselle",
  zipcode:"33000",
  city: "Bordeaux",
})
b.perks.build({
  perk: "Une formation offerte",
  description: "Cool",
  permanent: true,
  active: true
})

b = Business.create({
  name: "W.A.N",
  email: "wan@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"15 place du parlement saint pierre",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "10% offert",
  description: "Cool",
  permanent: true,
  active: true
})

b = Business.create({
  name: "Koken",
  email: "koken@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"3 cours d'intendance",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "15% offert",
  description: "Génial",
  permanent: true,
  active: true
})

b = Business.create({
  name: "O Txiki Café",
  email: "otxiki@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"45 cours victor hugo",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "10% offert",
  description: "Cool",
  permanent: true,
  active: true
})

b = Business.create({
  name: "ToutNet Eco",
  email: "toutnet@gmail.com",
  password: "123nuage",
  business_category_id: 20,
  street:"40 rue judaïque",
  zipcode:"33000",
  city: "Bordeaux"
})
b.perks.build({
  perk: "20% offert",
  description: "Cool",
  permanent: true,
  active: true
})
