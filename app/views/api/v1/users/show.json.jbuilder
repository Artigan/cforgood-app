json.extract! @user, :id, :first_name, :last_name, :name, :ambassador
json.picture @user.picture.url(:card)
json.extract! @user, :member, :trial_done, :birthday, :subscription, :amount, :street, :zipcode, :city
json.status @user.status
if @user.supervisor_id.present?
  json.logo_member_card @user.supervisor_id.logo.url(:thumb)
elsif @user.ecosystem_id.present?
  json.logo_member_card Business.find(ecosystem_id).logo.url(:thumb)
else
  json.logo_member_card nil
end

json.cause_attributes do
  json.extract! @cause, :name, :city
  json.picture @cause.picture.url(:card)
  json.total_donation @total_donation
end

json.donation_attributes do
  json.array! @payments do |payment|
    json.cause_name payment.cause.name
    json.created_at payment.created_at
    json.amount payment.amount
  end
end

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

json.first_perk_offer_attributes do
  if @first_perk_offer.present?
    json.business_id @first_perk_offer.business_id
    json.address_id Business.find(@first_perk_offer.business_id).main_address.id
    json.perk_id @first_perk_offer.id
  end
end

json.uses_without_feedback do
  json.array! @uses_without_feedback do |uses_without_feedback|
    json.extract! uses_without_feedback, :id, :perk_name, :business_name, :created_at
  end
end


