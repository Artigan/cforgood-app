# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


BusinessCategory.destroy_all
Business.destroy_all

path = "/Users/Didi/Desktop/CforGood/images/Business/"

puts "--------CREATE BUSINESS CATEGORIES--------"
bar = BusinessCategory.create!({
  name: "Bars & Restaurants"
  })

shop = BusinessCategory.create!({
  name: "Shopping"
  })

tiers = BusinessCategory.create!({
  name: "Tiers Lieux"
  })

epicerie = BusinessCategory.create!({
  name: "Epicerie"
  })

beauty =  BusinessCategory.create!({
  name: "Beauté / Bien être"
  })
puts "--------END BUSINESS CATEGORIES-----------"

puts "--------CREATE PERIODICITIES--------------"
semaine = Periodicity.create!({
  name: "Semaine"
  })

mois = BusinessCategory.create!({
  name: "Mois"
  })

annee = BusinessCategory.create!({
  name: "Année"
  })
puts "--------END PERIODICITIES-----------------"



puts "--------NEW BUSINESS CATEGORIES-----------"
business_attributes = {
  name: "Do you Speak Français ?",
  email:  "bonjour@dysfrançais.com",
  password: "doyouspeakfrancais",
  leader_first_name: "Gaëlle",
  leader_last_name: "Voisin",
  leader_description: "Nous sommes Gaëlle et Maxime, en couple depuis bientôt 5 ans. Nous avons 22 et 30 ans et nous avons ouvert notre magasin en juillet 2015. Avant, Gaëlle travaillait déjà dans la mode, Maxime était journaliste indépendant. Nous avons fait ce choix qui nous tient à cœur pour mettre en lumière le savoir faire des gens qui nous entourent, et surtout montrer que le Made in France peut être abordable!",
  business_category_id: shop,
  description: "Do you speak français c'est un concept store et lieu de vie 100% Made in France où l'on trouve de la mode H/F/enfants, des cosmétiques, de la beauté, des accessoires, de la maroquinerie, des bijoux et plein d'autres choses faites par des gens près de chez vous!",
  street: "93 rue notre dame",
  zipcode: "33000",
  city: "Bordeaux",
  url: "http://dysfrancais.jimdo.com/",
  facebook: "www.facebook.fr/doyouspeakfrancais",
  instagram: "www.instagram.com/doyouspeakfrancais",
  picture: File.new("#{path}DYSF.jpg"),
  picture_leader: File.new("#{path}DYSF2.jpg")
}

puts "--------CREATE BUSINESSES--------"
b = Business.new(business_attributes)
b.save
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

puts "--------NEW BUSINESS CATEGORIES-----------"
business_attributes = {
  name: "Koken",
  email:  "boutiquekoken@gmail.com",
  password: "boutiquekoken",
  leader_first_name: "Carole",
  leader_last_name: "Girard",
  leader_description: "Je m'appelle Carole Girard. De Taiwan à l'Uruguay, en passant par des épisodes de vie en Tunisie, en Argentine ou encore au Vietnam, j'ai rencontré des personnes et des cultures. De ces rencontres, j'ai acquis des convictions sur l'importance de la qualité des relations humaines dans un univers de partage et de mutualisation des connaissances. Je souhaite AGIR en proposant une vision de la mode éthique à haute valeur esthétique, PROMOUVOIR auprès du grand public de jeunes créateurs orientés vers une démarche écologique et raisonnée, SOUTENIR l'emploi et valoriser l'économie locale et le tissu social et enfin CREER une ambiance, un espace cosy où la mode côtoie l'éthique et le chic.",
  business_category_id: shop,
  description: "La boutique Koken oeuvre pour la mode éthique. C'est une marque respectueuse de l'Homme, des valeurs de l'ouvrage et de l'environnement. Elle propose des articles de mode conçus par des créateurs et stylistes. Née en 2015, Koken est destinée aux femmes qui recherchent des vêtements chics, tendances et éthiques. L'objectif est de faire connaitre une alternative au commerce de masse et à la production industrielle qui cause de nombreux problèmes humains comme écologiques.",
  street: "13 Place Puy Paulin ",
  zipcode: "33000",
  city: "Bordeaux",
  phone: "0981463968",
  url: "http://www.boutique-koken.fr/",
  facebook: "https://www.facebook.com/Boutique-KOKEN-961622623877174/?fref=ts",
  picture: File.new("#{path}Koken.jpg"),
  picture_leader: File.new("#{path}Koken_leader.jpg")
  }

puts "--------CREATE BUSINESSES--------"
b = Business.new(business_attributes)
b.save
business_id = b.id

perks_attributes = [{
    perk: "15% offert",
    description: "",
    detail: "Valable sur le premier achat",
    times: "1",
    period: "",
    permanent: "true",
    active: "true",
    business_id: business_id
  },
  {
    perk: "5% offert", description: "",
    detail: "Valable sur l’ensemble de la gamme",
    times: "",
    period: "",
    permanent: "true",
    active: "true",
    business_id: business_id
  }]

puts "--------CREATE PERKS-----------"
perks_attributes.each do |params|
    Perk.create(params)
  end
puts "--------END BUSINESS-----------"

puts "--------NEW BUSINESS CATEGORIES-----------"
business_attributes = {
  name: "Ô Merveilleux",
  email:  "epicerieomerveilleux@gmail.com",
  password: "omerveilleux",
  leader_first_name: "Julian",
  leader_last_name: "Saint André",
  leader_description: "Je suis un épicurien né à paris et qui a grandi à la campagne dans le sud de la france je suis un amoureux du bon produit, tant que c'est naturel sans cochonneries industrielle !!",
  business_category_id: epicerie,
  description: "Ô Merveilleux est une épicerie fine installée dans le quartier des Chartrons. Elle est spécialisée dans la vente de produits naturels et bio",
  street: "49 Cours de la Martinique",
  zipcode: "33300",
  city: "Bordeaux",
  phone: "0557895032",
  url: "https://www.facebook.com/epicerieomerveilleuxbordeaux/?fref=ts",
  picture: File.new("O Merveilleux.jpg"),
  picture_leader: File.new("O Merveilleux_leader.jpg")
  }

puts "--------CREATE BUSINESSES--------"
b = Business.new(business_attributes)
b.save
business_id = b.id

perks_attributes = [{
  perk: "10% de remise",
  detail: "Non cumulable avec d’autres promotions",
  permanent: "true",
  active: "true",
  business_id: business_id
}]

puts "--------CREATE PERKS-----------"
perks_attributes.each do |params|
    Perk.create(params)
  end
puts "--------END BUSINESS-----------"

puts "--------NEW BUSINESS CATEGORIES-----------"
business_attributes = {
  name: "Naturôme",
  email: "bonjour@naturome.fr",
  password: "naturome",
  leader_first_name: "Elodie",
  leader_last_name: "Brillaud",
  leader_description: "Naturôme est né de la rencontre de la naturopathie avec une volonté d'entreprendre de façon responsable, au service de la santé. L'espace a été créé de façon la plus écologique possible, comme un lieu d'échanges et de rencontres.",
  business_category_id: beauty,
  description: "Naturôme est le 1er centre de naturopathie à Bordeaux. Son objectif est de regrouper et proposer l'ensemble des techniques naturelles au service de l'hygiène de vie et de la prévention santé. Sauna, massages, consultations, pratiques corporelles douces, thérapies complémentaires, esthétique bio...",
  street: "7 impasse Saint Jean",
  zipcode: "33800",
  city: "Bordeaux",
  phone: "0556782509",
  url: "http://naturome.fr/",
  facebook: "https://www.facebook.com/naturome/?fref=ts",
  twitter: "https://twitter.com/CentreNaturome",
  instagram: "https://www.instagram.com/naturome_bordeaux/",
  picture: File.new("Naturome.jpg"),
  picture_leader: File.new("Naturome_leader.jpg")
  }

puts "--------CREATE BUSINESSES--------"
b = Business.new(business_attributes)
b.save
business_id = b.id

perks_attributes = [{
  perk: "20% Offert",
  detail: "Valable sur le sauna",
  permanent: "true",
  active: "true",
  business_id: business_id
}]

puts "--------CREATE PERKS-----------"
perks_attributes.each do |params|
    Perk.create(params)
  end
puts "--------END BUSINESS-----------"

puts "--------NEW BUSINESS CATEGORIES-----------"
business_attributes = {
  name: "W.A.N",
  email:  "contact@wanweb.fr",
  password: "wearenothing",
  leader_first_name: "Charles",
  leader_last_name: "Burke",
  leader_description: "",
  business_category_id: shop,
  description: "Concept store existant depuis 2009 proposant exclusivement des articles fabriqués en France ou en Europe avec des matériaux verts ou recyclés. Fabriquant de la marque de sacs et accessoires FANTOME, 100% made in France avec des chambres à air de vélo recyclées. Egalement galerie d'art au sous-sol, magnifique cave voûtée.",
  street: "1 rue des lauriers ",
  zipcode: "33000",
  city: "Bordeaux",
  phone: "0556481541",
  facebook: "https://www.facebook.com/Wan-we-are-nothing-345718002111418/timeline/",
  twitter: "https://twitter.com/wanbordeaux",
  picture: File.new("WAN.jpg"),
  picture_leader: File.new("WAN_leader.jpg")
}

puts "--------CREATE BUSINESSES--------"
b = Business.new(business_attributes)
b.save
business_id = b.id

perks_attributes = [{
  perk: "10% Offert",
  detail: "Valable sur l’ensemble de la marque Fantôme",
  permanent: "true",
  active: "true",
  business_id: business_id
}]

puts "--------CREATE PERKS-----------"
perks_attributes.each do |params|
    Perk.create(params)
  end
puts "--------END BUSINESS-----------"
