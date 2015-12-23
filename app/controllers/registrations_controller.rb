class RegistrationsController < Devise::RegistrationsController

  def update_cause
    if params[:_method] != nil
      # Select from dropdown
      @user = User.find_by_id(params[:resource])
      @user.update_attribute("cause_id", params[:cause_id][:cause_id])
    else
      # Select from onclick
      current_user.update_attribute("cause_id", params[:cause_id])
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def update_subscription
    @user = User.find_by_id(params[:resource])
    @user.update_attribute("subscription", params[:user][:subscription])
    @user.update_attribute("date_subscription", Time.now)
    redirect_to :back
  end

  def update
    current_user.update(user_params)
    if current_user.save
      respond_to do |format|
        format.html {redirect_to :back}
        format.js {}
      end
    else
      respond_to do |format|
        format.html {redirect_to :back}
        format.js {}
      end
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
    params.require(:user).permit(:first_name, :last_name, :email, :picture)
  end
end
