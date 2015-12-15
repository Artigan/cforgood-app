class RegistrationsController < Devise::RegistrationsController

  skip_before_filter :verify_authenticity_token, only: :update_cause

  def update_cause
    if params[:_method] != nil
      # Select from dropdown
      current_user.update_cause_id!(params[:cause_id][:cause_id])
    else
      # Select from onclick
      current_user.update_cause_id!(params[:cause_id])
    end
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
