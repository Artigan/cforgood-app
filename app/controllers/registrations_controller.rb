class RegistrationsController < Devise::RegistrationsController

  def update_cause
    current_user.update_attribute("cause_id", params[:cause_id])
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def update_profile
    current_user.update(user_params)
    current_user.save
    respond_to do |format|
        format.html {redirect_to :back}
        format.js {}
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    if resource_name == :business
      pro_business_dashboard_path(resource)
    else
      dashboard_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :picture, :cause_id, :subscription)
  end
end
