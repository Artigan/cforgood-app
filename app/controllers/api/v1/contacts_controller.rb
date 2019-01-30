class Api::V1::ContactsController < Api::V1::BaseController

  acts_as_token_authentication_handler_for User

  def create
    errors = nil
    nb_contacts = current_user.contacts.size
    # Create promo code for the first time
    Partner.new.create_code_partner_user(current_user, "GOODSPONSOR" + current_user.id.to_s, false, true) if  nb_contacts == 0

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
          render_sponsorship_ok(nb_contacts)
        else
          render status: :unprocessable_entity, json: { error: "Error during sponsoring" }
        end
      else
        render_sponsorship_ok(nb_contacts)
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
        :phone)
    end
  end

  def render_sponsorship_ok(nb_contacts)
    render status: 200, json: { nb_contacts: nb_contacts,
                                sponsoring_done: current_user.sponsorship_done,
                                code_sponsor: current_user.sponsorship_done ? "GOODSPONSOR" + current_user.id.to_s : nil }
  end

  def manage_sponsorship
    # assignment promo code for the sponsor
    current_user.update_attributes(code_partner: "SPONSORSHIP", sponsorship_done: true)
    if current_user.subscription_id
      return true if StripeServices.new(user: current_user).update_subscription()
    else
      return true
    end
  end
end
