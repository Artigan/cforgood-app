class RegistrationsController < Devise::RegistrationsController

  skip_before_filter :verify_authenticity_token, only: :update

  def update
    current_user.update_cause_id!(params[:cause_id])
    redirect_to :back
  end

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
