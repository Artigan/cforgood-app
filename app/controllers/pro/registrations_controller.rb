class Pro::RegistrationsController < Devise::RegistrationsController

  def update_business
    current_business.update(business_params)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :street, :zipcode, :city, :url, :telephone, :email, :password, :description, :picture, :business_category_id, :facebook, :twitter, :instagram, :leader_picture,:leader_first_name, :leader_last_name, :leader_description, :leader_phone, :leader_email, :active, :online)
  end
end
