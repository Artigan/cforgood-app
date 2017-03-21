class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [ :show, :update ]

  def show
    @cause = current_user.cause
    @payments = current_user.payments
    @total_donation = @payments.sum(&:amount) if @payments.present?
    @partner = Partner.find_by_code_partner(@user.code_partner) unless @user.code_partner
    @beneficiary = Beneficiary.includes(:users).find_by_email(@user.email)
    @user_offering = @beneficiary.try(:users)
    if !current_user.uses.first.present?
      @first_perk_offer = Business.find(ENV['BUSINESS_ID_CFORGOOD'].to_i).perks.active.first
      @first_perk_offer = nil if !@first_perk_offer.perk_usable?(current_user)
    end
    @uses_without_feedback = @user.uses.without_feedback
  end

  def update
    if user_params[:subscription] == "X"
      if @user.stop_subscription!
        render status: 200, json: { status: "updated" }
      else
        render status: :unprocessable_entity, json: { error: @user.errors.full_messages}
      end
    elsif user_params[:cause_id] == "" || user_params[:cause_id] == nil
       render status: :unprocessable_entity, json: { error: "Cause_id present but null"}
    elsif (user_params[:subscription].present?  && ((user_params[:subscription] != "M" && user_params[:subscription] != "Y") || !user_params[:amount].present? || user_params[:amount] == 0)) || (user_params[:amount].present? && !user_params[:subscription].present?)
      render status: :unprocessable_entity, json: { error: "Inconsistent parameters"}
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
