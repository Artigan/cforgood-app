class Pro::RegistrationsController < Devise::RegistrationsController

  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  #   respond_to do |format|
  #     format.html {}
  #     format.js {}
  #   end
  # end

  # def after_update_path_for(resource)
  #   if resource_name == :business
  #     respond_to do |format|
  #       format.html {}
  #       format.js {}
  #     end
  #     pro_business_dashboard_path(resource)
  #   else
  #     member_user_dashboard_path(resource)
  #   end
  # end

  def update_business
    current_business.update(business_params)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :street, :zipcode, :city, :url, :telephone, :email, :description, :picture, :business_category_id, :facebook, :twitter, :instagram, :leader_picture,:leader_first_name, :leader_last_name, :leader_description, :active, :online)
  end
end
