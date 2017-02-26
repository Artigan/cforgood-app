json.extract! @user, :id, :first_name, :last_name, :name
json.picture @user.picture.url(:card)
json.extract! @user, :member, :trial_done

json.trial_attributes do
  json.date_end_partner @user.date_end_partner
  if @partner.present?
    json.partner_name @partner.name
  else
    json.partner_name nil
  end
end

json.gift_attributes do
  if @beneficiary.present?
    json.code_partner @user.code_partner
    json.user_offering_first_name @user_offering.first_name
    json.user_offering_last_name @user_offering.last_name
    json.nb_month_beneficiary @beneficiary.nb_month
  else
    json.code_partner nil
    json.user_offering_first_name nil
    json.user_offering_last_name nil
    json.nb_month_beneficiary nil
  end
end

json.uses_without_feedback do
  json.array! @uses_without_feedback do |uses_without_feedback|
    json.extract! uses_without_feedback, :id, :perk_name, :business_name, :created_at
  end
end

