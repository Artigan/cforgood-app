class Member::UsersController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def new
    @employee = User.new
  end

  def create
    @employee = current_user.users.build(users_params)
    @employee.password = "cforgood"
    # @employee.password = Devise.friendly_token.first(8)
    if @employee.save
      redirect_to member_user_supervisor_account_path(current_user)
    else
      render :new
    end
  end

  def update
    @employee = User.find(params[:id])
    @employee.manager = nil
    @employee.save
    redirect_to member_user_supervisor_account_path(current_user)
  end

  private

  def users_params
    params.require(:user).permit(:email, :first_name, :last_name, :city, :zipcode, :supervisor_id)
  end
end
