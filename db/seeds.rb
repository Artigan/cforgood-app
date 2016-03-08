

# Chemin pour lese images
path = "/Users/Didi/Desktop/projets/CforGood/images/Seed/"

#----------------------------------------------------
# Création table BUSINESS_CATEGORIES
#----------------------------------------------------

BusinessCategory.destroy_all

puts "--------CREATE BUSINESS CATEGORIES--------"

perso = BusinessCategory.create!({
  name: "Développement personnel",
  picture: File.new("#{path}cat_icons/developpement.png"),
  color: "#36d3da",
  marker_symbol: "marker-developpement"
 })

fitness = BusinessCategory.create!({
  name: "Santé & Fitness",
  picture: File.new("#{path}cat_icons/fitness.png"),
  color: "#c386be",
  marker_symbol: "marker-forme"
 })

epicerie = BusinessCategory.create!({
  name: "Marchés & Epiceries",
  picture: File.new("#{path}cat_icons/market.png"),
  color: "#eeaa06",
  marker_symbol: "marker-epicerie"
 })

shopping = BusinessCategory.create!({
  name: "Shopping",
  picture: File.new("#{path}cat_icons/shopping.png"),
  color: "#f55b5b",
  marker_symbol: "marker-shopping"
 })

maison = BusinessCategory.create!({
  name: "Maison & Jardin",
  picture: File.new("#{path}cat_icons/maison.png"),
  color: "#adcb40",
  marker_symbol: "marker-maison"
 })

loisirs = BusinessCategory.create!({
  name: "Loisirs & Sorties",
  picture: File.new("#{path}cat_icons/loisirs.png"),
  color: "#1da1df",
  marker_symbol: "marker-loisirs"
 })

coffee = BusinessCategory.create!({
  name: "Cafés & Lieux de vie",
  picture: File.new("#{path}cat_icons/coffee.png"),
  color: "#7f5b0a",
  marker_symbol: "marker-coffee"
 })

beaute = BusinessCategory.create!({
  name: "Beauté & Bien Être",
  picture: File.new("#{path}cat_icons/beauty.png"),
  color: "#867486",
  marker_symbol: "marker-bienetre"
 })

bars = BusinessCategory.create!({
  name: "Bars & Restaurants",
  picture: File.new("#{path}cat_icons/restaurant.png"),
  color: "#db6f3a",
  marker_symbol: "marker-restaurant"
 })

puts "--------END BUSINESS CATEGORIES-----------"

# # ----------------------------------------------
# # Création table PERIODICITIES
# # ----------------------------------------------

# Periodicity.destroy_all

# puts "--------CREATE PERIODICITIES--------------"
# semaine = Periodicity.create!({
#   period: "Semaine"
#   })

# mois = Periodicity.create!({
#   period: "Mois"
#   })

# annee = Periodicity.create!({
#   period: "Année"
#   })
# puts "--------END PERIODICITIES-----------------"



#----------------------------------------------------
#----------------------------------------------------
# Création table BUSINESS et PERK
#----------------------------------------------------
#----------------------------------------------------

# Business.destroy_all
# Perk.destroy_all

# #-------------------------------------------------
# # Variables table BUSINESS_CATEGORIES & CATEGORIES
# #-------------------------------------------------
# puts "--------READ BUSINESS CATEGORIES-----------"

# perso = BusinessCategory.find_by_name("Développement personnel",)
# fitness = BusinessCategory.find_by_name("Santé & Fitness"),
# epicerie = BusinessCategory.find_by_name("Marchés & Epiceries"),
# shopping = BusinessCategory.find_by_name("Shopping"),
# maison = BusinessCategory.find_by_name("Maison & Jardin"),
# loisirs = BusinessCategory.find_by_name("Loisirs & Sorties"),
# coffee = BusinessCategory.find_by_name("Cafés & Lieux de vie"),
# beaute = BusinessCategory.find_by_name("Beauté & Bien Être"),
# bars = BusinessCategory.find_by_name("Bars & Restaurants"),

# puts "--------END READ BUSINESS CATEGORIES-----------"


# # puts "--------READ PERIODICITIES--------------"

# # semaine = Periodicity.find_by_period("Semaine")
# # mois = Periodicity.find_by_period("Mois")
# # annee = Periodicity.find_by_period("Année")

# # puts "--------END READ PERIODICITIES-----------------"

# puts "--------NEW BUSINESS-----------"
# business_attributes = {
#   name: "Do you Speak Français ?",
#   email:  "bonjour@dysfrançais.com",
#   password: "doyouspeakfrancais",
#   leader_first_name: "Gaëlle",
#   leader_last_name: "Voisin",
#   leader_description: "Nous sommes Gaëlle et Maxime, en couple depuis bientôt 5 ans. Nous avons 22 et 30 ans et nous avons ouvert notre magasin en juillet 2015. Avant, Gaëlle travaillait déjà dans la mode, Maxime était journaliste indépendant. Nous avons fait ce choix qui nous tient à cœur pour mettre en lumière le savoir faire des gens qui nous entourent, et surtout montrer que le Made in France peut être abordable!",
#   business_category_id: shopping.id,
#   description: "Do you speak français c'est un concept store et lieu de vie 100% Made in France où l'on trouve de la mode H/F/enfants, des cosmétiques, de la beauté, des accessoires, de la maroquinerie, des bijoux et plein d'autres choses faites par des gens près de chez vous!",
#   street: "93 rue notre dame",
#   zipcode: "33000",
#   city: "Bordeaux",
#   url: "http://dysfrancais.jimdo.com/",
#   facebook: "www.facebook.fr/doyouspeakfrancais",
#   instagram: "www.instagram.com/doyouspeakfrancais",
#   picture: File.new("#{path}DYSF.jpg"),
#   leader_picture: File.new("#{path}DYSF2.jpg")
# }

# puts "--------CREATE BUSINESSES--------"
# b = Business.create(business_attributes)
# business_id = b.id
# puts b.errors.messages


# perks_attributes = [
#   {
#     perk: "Un thé offert",
#     description: "Sur présentation de votre carte de membre, nous vous accueillerons avec un thé et un grand sourire pour faire connaissance ! (Du mardi au vendredi)",
#     detail: "Valable une seule fois",
#     times: "1",
#     durable: "true",
#     active: "true",
#     business_id: business_id
#   }]

# puts "--------CREATE PERKS-----------"
# perks_attributes.each do |params|
#     Perk.create(params)
#   end

# puts "--------END BUSINESS-----------"

# puts "--------NEW BUSINESS-----------"
# business_attributes = {
#   name: "Koken",
#   email:  "boutiquekoken@gmail.com",
#   password: "boutiquekoken",
#   leader_first_name: "Carole",
#   leader_last_name: "Girard",
#   leader_description: "Je m'appelle Carole Girard. De Taiwan à l'Uruguay, en passant par des épisodes de vie en Tunisie, en Argentine ou encore au Vietnam, j'ai rencontré des personnes et des cultures. De ces rencontres, j'ai acquis des convictions sur l'importance de la qualité des relations humaines dans un univers de partage et de mutualisation des connaissances. Je souhaite AGIR en proposant une vision de la mode éthique à haute valeur esthétique, PROMOUVOIR auprès du grand public de jeunes créateurs orientés vers une démarche écologique et raisonnée, SOUTENIR l'emploi et valoriser l'économie locale et le tissu social et enfin CREER une ambiance, un espace cosy où la mode côtoie l'éthique et le chic.",
#   business_category_id: shopping.id,
#   description: "La boutique Koken oeuvre pour la mode éthique. C'est une marque respectueuse de l'Homme, des valeurs de l'ouvrage et de l'environnement. Elle propose des articles de mode conçus par des créateurs et stylistes. Née en 2015, Koken est destinée aux femmes qui recherchent des vêtements chics, tendances et éthiques. L'objectif est de faire connaitre une alternative au commerce de masse et à la production industrielle qui cause de nombreux problèmes humains comme écologiques.",
#   street: "13 Place Puy Paulin ",
#   zipcode: "33000",
#   city: "Bordeaux",
#   telephone: "0981463968",
#   url: "http://www.boutique-koken.fr/",
#   facebook: "https://www.facebook.com/Boutique-KOKEN-961622623877174/?fref=ts",
#   picture: File.new("#{path}Koken.jpg"),
#   leader_picture: File.new("#{path}Koken_leader.jpg")
#   }

# puts "--------CREATE BUSINESSES--------"
# b = Business.create(business_attributes)
# business_id = b.id
# puts b.errors.messages

# perks_attributes = [{
#     perk: "15% offert",
#     description: "",
#     detail: "Valable sur le premier achat",
#     times: "1",
#     appel: "true",
#     active: "true",
#     business_id: business_id
#   },
#   {
#     perk: "5% offert", description: "",
#     detail: "Valable sur l’ensemble de la gamme",
#     times: "2",
#     periodicity_id: semaine,
#     durable: "true",
#     active: "true",
#     business_id: business_id
#   }]

# puts "--------CREATE PERKS-----------"
# perks_attributes.each do |params|
#     Perk.create(params)
#   end
# puts "--------END BUSINESS-----------"

# puts "--------NEW BUSINESS-----------"
# business_attributes = {
#   name: "Ô Merveilleux",
#   email:  "epicerieomerveilleux@gmail.com",
#   password: "omerveilleux",
#   leader_first_name: "Julian",
#   leader_last_name: "Saint André",
#   leader_description: "Je suis un épicurien né à paris et qui a grandi à la campagne dans le sud de la france je suis un amoureux du bon produit, tant que c'est naturel sans cochonneries industrielle !!",
#   business_category_id: epicerie.id,
#   description: "Ô Merveilleux est une épicerie fine installée dans le quartier des Chartrons. Elle est spécialisée dans la vente de produits naturels et bio",
#   street: "49 Cours de la Martinique",
#   zipcode: "33300",
#   city: "Bordeaux",
#   telephone: "0557895032",
#   url: "https://www.facebook.com/epicerieomerveilleuxbordeaux/?fref=ts",
#   picture: File.new("#{path}OMerveilleux.jpg"),
#   leader_picture: File.new("#{path}OMerveilleux_leader.jpg")
#   }

# puts "--------CREATE BUSINESSES--------"
# b = Business.create(business_attributes)
# business_id = b.id
# puts b.errors.messages

# perks_attributes = [{
#   perk: "10% de remise",
#   detail: "Non cumulable avec d’autres promotions",
#   appel: "true",
#   active: "true",
#   business_id: business_id
# }]

# puts "--------CREATE PERKS-----------"
# perks_attributes.each do |params|
#     Perk.create(params)
#   end
# puts "--------END BUSINESS-----------"

# puts "--------NEW BUSINESS-----------"
# business_attributes = {
#   name: "Naturôme",
#   email: "bonjour@naturome.fr",
#   password: "naturome",
#   leader_first_name: "Elodie",
#   leader_last_name: "Brillaud",
#   leader_description: "Naturôme est né de la rencontre de la naturopathie avec une volonté d'entreprendre de façon responsable, au service de la santé. L'espace a été créé de façon la plus écologique possible, comme un lieu d'échanges et de rencontres.",
#   business_category_id: beaute.id,
#   description: "Naturôme est le 1er centre de naturopathie à Bordeaux. Son objectif est de regrouper et proposer l'ensemble des techniques naturelles au service de l'hygiène de vie et de la prévention santé. Sauna, massages, consultations, pratiques corporelles douces, thérapies complémentaires, esthétique bio...",
#   street: "7 impasse Saint Jean",
#   zipcode: "33800",
#   city: "Bordeaux",
#   telephone: "0556782509",
#   url: "http://naturome.fr/",
#   facebook: "https://www.facebook.com/naturome/?fref=ts",
#   twitter: "https://twitter.com/CentreNaturome",
#   instagram: "https://www.instagram.com/naturome_bordeaux/",
#   picture: File.new("#{path}Naturome.jpg"),
#   leader_picture: File.new("#{path}Naturome_leader.jpg")
#   }

# puts "--------CREATE BUSINESSES--------"
# b = Business.create(business_attributes)
# business_id = b.id
# puts b.errors.messages

# perks_attributes = [{
#   perk: "20% Offert",
#   detail: "Valable sur le sauna",
#   appel: "true",
#   active: "true",
#   business_id: business_id
# }]

# puts "--------CREATE PERKS-----------"
# perks_attributes.each do |params|
#     Perk.create(params)
#   end
# puts "--------END BUSINESS-----------"

# puts "--------NEW BUSINESS -----------"
# business_attributes = {
#   name: "W.A.N",
#   email:  "contact@wanweb.fr",
#   password: "wearenothing",
#   leader_first_name: "Charles",
#   leader_last_name: "Burke",
#   leader_description: "",
#   business_category_id: shopping.id,
#   description: "Concept store existant depuis 2009 proposant exclusivement des articles fabriqués en France ou en Europe avec des matériaux verts ou recyclés. Fabriquant de la marque de sacs et accessoires FANTOME, 100% made in France avec des chambres à air de vélo recyclées. Egalement galerie d'art au sous-sol, magnifique cave voûtée.",
#   street: "1 rue des lauriers ",
#   zipcode: "33000",
#   city: "Bordeaux",
#   telephone: "0556481541",
#   facebook: "https://www.facebook.com/Wan-we-are-nothing-345718002111418/timeline/",
#   twitter: "https://twitter.com/wanbordeaux",
#   picture: File.new("#{path}WAN.jpg"),
#   leader_picture: File.new("#{path}WAN_leader.jpg")
# }
# # puts b.errors.messages

# puts "--------CREATE BUSINESSES--------"
# b = Business.create(business_attributes)
# business_id = b.id

# perks_attributes = [{
#   perk: "10% Offert",
#   detail: "Valable sur l’ensemble de la marque Fantôme",
#   appel: "true",
#   active: "true",
#   business_id: business_id
# }]

# puts "--------CREATE PERKS-----------"
# perks_attributes.each do |params|
#     Perk.create(params)
#   end
# puts "--------END BUSINESS-----------"

