class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [ :show, :update ]

  def show
    @partner = Partner.find_by_code_partner(@user.code_partner) unless @user.code_partner
    @uses_without_feedback = @user.uses.without_feedback
    @beneficiary = Beneficiary.includes(:users).find_by_email(@user.email)
    @user_offering = @beneficiary.try(:users)
  end

  def update
    if @user.update(user_params)
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
    params.require(:user).permit(:cause_id)
  end
end
