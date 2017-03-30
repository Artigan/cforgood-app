class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [ :show, :update ]

  def show
    @cause = current_user.cause
    @payments = current_user.payments
    @total_donation = @payments.sum(&:donation) if @payments.present?
    @partner = Partner.find_by_code_partner(@user.code_partner) unless @user.code_partner
    @beneficiary = Beneficiary.includes(:users).find_by_email(@user.email)
    @user_offering = @beneficiary.try(:users)
    if !current_user.uses.first.present?
      if !current_user.member
        @first_perk_offer = Business.find(ENV['BUSINESS_ID_CFORGOOD']).perks.active.first
      elsif current_user.business_supervisor_id
        @first_perk_offer = Business.find(business_supervisor_id).perks.active.first
      end
    end
    @uses_without_feedback = @user.uses.without_feedback
  end

  def update
    if user_params[:subscription] == "X"
      @user.stop_subscription!
      render status: 200, json: { status: "updated" }
    elsif user_params[:code_partner].present? && @user.code_partner.present?
      render status: :unprocessable_entity, json: { error: "A code_partner already filled"}
    elsif user_params.include?("cause_id") && !user_params[:cause_id].present?
      render status: :unprocessable_entity, json: { error: "Cause required"}
    elsif user_params.include?("subscription") && user_params[:subscription] != "M" && user_params[:subscription] != "Y"
      render status: :unprocessable_entity, json: { error: "Unknowm subscription value"}
    elsif ( user_params.include?("subscription") && !user_params.include?("amount") )  ||  ( user_params.include?("amount") && !user_params.include?("subscription") )
      render status: :unprocessable_entity, json: { error: "Subscription or amount are both required"}
    elsif ( user_params[:subscription] == "M" && ( user_params[:amount] < 1 ||  user_params[:amount] > 50 )) || ( user_params[:subscription] == "Y" && ( user_params[:amount] < 30 ||  user_params[:amount] > 500 ) )
      render status: :unprocessable_entity, json: { error: "Invalid value of subscription or amount"}
    elsif user_params[:amount].present? && !user_params[:subscription].present?
        render status: :unprocessable_entity, json: { error: "Subscription required if Amount present"}
    elsif @user.update(user_params)
      render status: 200, json: { status: "updated" }
    else
      render status: :unprocessable_entity, json: { error: @user.errors.full_messages}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user  # For Pundit
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :birthday,
      :subscription,
      :amount,
      :code_partner,
      :street,
      :zipcode,
      :city,
      :cause_id,
      :picture)
  end
end
