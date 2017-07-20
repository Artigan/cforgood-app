class Api::V1::ContactsController < Api::V1::BaseController

  acts_as_token_authentication_handler_for User

  def create

    errors = nil
    nb_contacts = current_user.contacts.size

    contact_params.each do |contact|
      @contact = current_user.contacts.build(contact)
      authorize @contact
      if !@contact.save
        errors = @contact.errors.full_messages[0]
        break
      else
        nb_contacts += 1
      end
    end
    if errors
      render status: :unprocessable_entity, json: { error: @contact.email + " : " + errors}
    else
      if !current_user.sponsorship_done && nb_contacts >= 5
        if manage_sponsorship
          render status: 200, json: { nb_contacts: nb_contacts,
                                      quotas_reached: nb_contacts >= 5 ? true : false,
                                      sponsoring_done: current_user.sponsorship_done,
                                      code_sponsor: "GOODSPONSOR" + current_user.id_ti_s }
        else
          render status: :unprocessable_entity, json: { error: "Error during sponsoring" }
        end
      else
        render status: 200, json: { nb_contacts: nb_contacts,
                                    quotas_reached: nb_contacts >= 5 ? true : false,
                                    sponsoring_done: current_user.sponsorship_done }
      end
    end
  end

  private

  def contact_params
    params.require(:contacts).map do |contact|
      contact.permit(
        :id,
        :user_id,
        :email,
        :first_name,
        :last_name,
        :city,
        :telephone,
        :used)
    end
  end

  def manage_sponsorship
    # create new sponsorship_code
    code_partner = "GOODSPONSOR" + current_user.id.to_s
    if Partner.new.create_code_partner_user(current_user, code_partner, false, true)
      # assignment promo code for the sponsor
      current_user.updates(code_partner: "SPONSORSHIP", sponsorship_done: true)
      if current_user.subscription_id
        return true if StripeServices.new(user: current_user).update_subscription()
      else
        return true
      end
    end
    return false
  end
end


