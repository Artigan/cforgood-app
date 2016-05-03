class Pro::RegistrationsController < Devise::RegistrationsController

  def update_business
    if business_params[:password].present?
      current_business.update(business_params)
      sign_in(current_business, bypass: true)
    else
      current_business.update_without_password(business_params)
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :street, :zipcode, :city, :url, :telephone, :email, :password, :description, :picture, :business_category_id, :facebook, :twitter, :instagram, :leader_picture,:leader_first_name, :leader_last_name, :leader_description, :leader_phone, :leader_email, :active, :shop, :online, :itinerant, addresses_attributes: [ :_destroy, :id, :active, :street, :zipcode, :city ])
  end
end
