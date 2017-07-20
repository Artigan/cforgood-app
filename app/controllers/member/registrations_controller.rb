class Member::RegistrationsController < Devise::RegistrationsController

  include Modules::ModulePayment

  def update_cause
    old_acct_id = current_user.cause.acct_id

    current_user.update_attributes(cause_id: user_params[:cause_id])

    if current_user.subscription_id.present?
      change_connected_account(current_user, current_user.cause.acct_id, old_acct_id)
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def update_profile
    if user_params[:password].present?
      current_user.update(user_params)
      sign_in(current_user, bypass: true)
    else
      current_user.update_without_password(user_params)
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def stop_subscription
    current_user.stop_subscription!
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :password,
      :email,
      :picture,
      :picture_cache,
      :cause_id,
      :subscription,
      :birthday,
      :street,
      :zipcode,
      :city,
      :amount,
      :code_partner,
      :phone,
      :logo
    )
  end
end
