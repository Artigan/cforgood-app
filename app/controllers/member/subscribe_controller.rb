class Member::SubscribeController < ApplicationController

  include Modules::ModulePayment

  before_action :authenticate_user!

  def new
    @partner = Partner.find_by_code_partner(current_user.code_partner.upcase) if current_user.code_partner.present?
    if @partner && @partner.supervisor_id.present?
      @causes = Cause.active.where(supervisor_id: @partner.supervisor_id).includes(:cause_category)
    else
      @causes = Cause.active.all.includes(:cause_category)
    end
  end

  def create
    execute_payin(params)
    if request.referer.include?("subscribe")
      redirect_to member_user_dashboard_path(current_user)
    else
      redirect_to member_user_profile_path(current_user, anchor: 'subscription' )
    end
  end

  def update
    if current_user.update_without_password(user_params)
      execute_payin(params)
    end
    respond_to :js
  end

  def destroy
    if current_user.user_histories.last.code_partner == current_user.code_partner
      current_user.user_histories.last.delete
      current_user.code_partner = nil
      current_user.date_end_partner = nil
      current_user.save
      current_user.user_histories.last.delete
    end
    respond_to :js
  end

  def gift
  end

  private

  def execute_payin(params)

    # No payment for gift
    if request.referer.include?('gift')
      if !current_user.member
        current_user.code_partner = "SIGNUPGIFT"
        current_user.member!
      end
      return
    end

    create_or_update_payment(current_user, params)
  end

  def card_params
    params.require(:card).permit(:id)
  end

  def user_params
    params.require(:user).permit(:subscription, :amount, :code_partner)
  end

  def stripe_params
    params.permit :stripeToken
  end
end
