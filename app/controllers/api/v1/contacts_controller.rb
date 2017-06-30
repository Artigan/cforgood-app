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
      render status: 200, json: { nb_contacts: nb_contacts, quotas_reached: nb_contacts >= 5 ? true : false  }
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
end


