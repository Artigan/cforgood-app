json.array! @businesses do |business|
  json.extract! business, :id, :name, :activity
  json.picture business.picture.url(:card)
  json.business_category_id business.business_category.id
  json.like business.like

  json.addresses do
    json.array! business.addresses do |address|
      json.extract! address, :id, :latitude, :longitude
    end
  end

  json.perks do
    json.array! business.perks.active do |perk|
      json.extract! perk, :id, :name, :flash
      json.times_remaining perk.flash ? perk.times - Use.where(perk_id: perk.id).count : 0
      json.picture perk.picture.url(:card)
      json.offer perk.offer_type
    end
  end
end

