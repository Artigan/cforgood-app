json.extract! @business,
  :id,
  :name,
  :activity,
  :url,
  :telephone,
  :email,
  :description,
  :business_category_id,
  :facebook,
  :twitter,
  :instagram,
  :leader_first_name,
  :leader_last_name,
  :leader_description,
  :online,
  :shop,
  :itinerant
json.picture @business.picture.url(:card)
json.leader_picture @business.leader_picture.url(:card)
json.extract! @business,
  :like,
  :unlike,
  :link_video

json.address do
  json.extract! @address,
    :id,
    :street,
    :zipcode,
    :city,
    :latitude,
    :longitude,
    :main
  json.timetables do
    json.array! @address.timetables do |timetable|
      json.day I18n.t("date.day_names")[timetable.day]
      json.start_at timetable.start_at.strftime("%H:%M")
      json.end_at timetable.end_at.strftime("%H:%M")
    end
  end
end

json.labels do
  json.array! @business.label_categories do |label_category|
    json.extract! label_category, :name, :picture
  end
end

json.perks do
  json.array! @business.perks do |perk|
    json.extract! perk,
      :id,
      :name,
      :description,
      :times,
      :start_date,
      :end_date,
      :active,
      :perk_code,
      :nb_views,
      :appel,
      :durable,
      :flash,
      :perk_detail_id,
      :all_day
    json.picture perk.picture.url(:card)
    json.times_remaining perk.flash && perk.times > 0 ? perk.times - Use.where(perk_id: perk.id).count : 0
    json.offer perk.offer_type
    json.usable_for_user perk.perk_in_time? && perk.perk_usable?(current_user)
  end
end
