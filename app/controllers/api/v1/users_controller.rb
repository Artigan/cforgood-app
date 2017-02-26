class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [ :show ]

  def show
    @partner = Partner.find_by_code_partner(@user.code_partner) unless @user.code_partner
    @uses_without_feedback = @user.uses.without_feedback
    @beneficiary = Beneficiary.includes(:users).find_by_email(@user.email)
    @user_offering = @beneficiary.try(:users)
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user  # For Pundit
  end
end
