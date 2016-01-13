class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def after_update_path_for(resource)
    if resource_name == :business
      respond_to do |format|
        format.html {}
        format.js {}
      end
      pro_business_dashboard_path(resource)
    else
      member_user_dashboard_path(resource)
    end
  end
end
