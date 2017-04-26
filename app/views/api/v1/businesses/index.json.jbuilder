json.array! @businesses do |business|
  json.extract! business, :id, :email, :name, :activity
  json.picture business.picture.url(:card)
  json.business_category_id business.business_category.id
  json.like business.like
  json.online business.online

  json.addresses do
    json.array! business.addresses do |address|
      json.extract! address, :id, :latitude, :longitude
    end
  end

  json.perks do
    json.array! business.perks.active do |perk|
      json.extract! perk, :id, :name, :flash
      json.picture perk.picture.url(:card)
      json.times_remaining perk.flash && perk.times > 0 ? perk.times - Use.where(perk_id: perk.id).count : 0
      json.offer perk.offer_type
      json.usable_for_user perk.perk_in_time? && perk.perk_usable?(current_user)
      json.nb_views perk.nb_views
    end
  end
end

