# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# BusinessCategory.destroy_all
# Business.destroy_all

# bar = BusinessCategory.create!({
#   name: "Bars & Restaurants"
#   })

# shop = BusinessCategory.create!({
#   name: "Shopping"
#   })

# tiers = BusinessCategory.create!({
#   name: "Tiers Lieux"
#   })

path = "/Users/Didi/Desktop/CforGood/images/Business/"

business_attributes = {
    name: "Do you Speak Français ?",
    email: "bonjour@dysfrancais.com",
    password: "doyouspeakfrancais",
    leader_first_name: "Gaëlle",
    leader_last_name: "Voisin",
    leader_description: "Nous sommes Gaëlle et Maxime, en couple depuis bientôt 5 ans. Nous avons 22 et 30 ans et nous avons ouvert notre magasin en juillet 2015. Avant, Gaëlle travaillait déjà dans la mode, Maxime était journaliste indépendant. Nous avons fait ce choix qui nous tient à cœur pour mettre en lumière le savoir faire des gens qui nous entourent, et surtout montrer que le Made in France peut être abordable!",
    business_category_id: 21,
    description: "Do you speak français c'est un concept store et lieu de vie 100% Made in France où l'on trouve de la mode H/F/enfants, des cosmétiques, de la beauté, des accessoires, de la maroquinerie, des bijoux et plein d'autres choses faites par des gens près de chez vous!",
    street: "93 rue notre dame",
    zipcode: "33000", city: "Bordeaux",
    url: "http://dysfrancais.jimdo.com/",
    facebook: "www.facebook.fr/doyouspeakfrancais",
    instagram: "www.instagram.com/doyouspeakfrancais",
    picture: File.new("#{path}DYSF.jpg"),
    leader_picture: File.new("#{path}DYSF2.jpg")
  }

puts "--------CREATE BUSINESS--------"
b = Business.new(business_attributes)
b.save
puts b
puts b.id
business_id = b.id

perks_attributes = [
  {
    perk: "Un thé offert",
    description: "Sur présentation de votre carte de membre, nous vous accueillerons avec un thé et un grand sourire pour faire connaissance ! (Du mardi au vendredi)",
    detail: "Valable une seule fois",
    times: "1",
    permanent: "true",
    active: "true",
    business_id: business_id
  }]

puts "--------CREATE PERKS-----------"
perks_attributes.each do |params|
    Perk.create(params)
  end
puts "--------END BUSINESS-----------"



# b = Business.create({
  # name: "Weecolab",
  # email: "weecolab@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"30 rue pomme d'or",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "50% offert",
  # description: "Pour les 3 premiers mois",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "Ex Aequo",
  # email: "exaequo@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"2 place camille julian",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "15% offert",
  # description: "Pour toi !",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "Do you speack français ?",
  # email: "dysf@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"30 rue notre dame",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "Un t-shit offert",
  # description: "Top !",
  # permanent: true,
  # active: true
# })
#
# b = Business.create!({
  # name: "Mon potager city",
  # email: "monpotagercity@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"10 rue david johnston",
  # zipcode:"33000",
  # city: "Bordeaux",
# })
# b.perks.build!({
  # perk: "Un panier offert",
  # description: "Incroyable !",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "Décalez",
  # email: "decalez@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"15 rue de la rousselle",
  # zipcode:"33000",
  # city: "Bordeaux",
# })
# b.perks.build({
  # perk: "Une formation offerte",
  # description: "Cool",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "W.A.N",
  # email: "wan@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"15 place du parlement saint pierre",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "10% offert",
  # description: "Cool",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "Koken",
  # email: "koken@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"3 cours d'intendance",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "15% offert",
  # description: "Génial",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "O Txiki Café",
  # email: "otxiki@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"45 cours victor hugo",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "10% offert",
  # description: "Cool",
  # permanent: true,
  # active: true
# })
#
# b = Business.create({
  # name: "ToutNet Eco",
  # email: "toutnet@gmail.com",
  # password: "123nuage",
  # business_category_id: 20,
  # street:"40 rue judaïque",
  # zipcode:"33000",
  # city: "Bordeaux"
# })
# b.perks.build({
  # perk: "20% offert",
  # description: "Cool",
  # permanent: true,
  # active: true
# })
