json.extract! @perk,
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
    :perk_detail_id
json.perk_detail_name @perk.perk_detail.name
json.all_day @perk.all_day
json.picture @perk.picture.url(:card)
json.offer @perk.offer_type
json.usable_for_user @perk.perk_in_time? && @perk.perk_usable?(current_user)

