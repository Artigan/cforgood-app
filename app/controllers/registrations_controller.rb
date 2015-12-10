class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    if resource_name == :business
      pro_business_metrics_path(resource)
    else
      dashboard_path
    end
  end

end
