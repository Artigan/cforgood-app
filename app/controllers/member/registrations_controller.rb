class Member::RegistrationsController < Devise::RegistrationsController

  def update_cause
    current_user.update_attribute("cause_id", params[:cause_id])
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def update_profile
    current_user.update(user_params)
    if current_user.save && request.referer.include?("user_profile")
      flash[:notice] = "Vos données ont été mises à jour."
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :picture, :cause_id, :subscription)
  end
end
