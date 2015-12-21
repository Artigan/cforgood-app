class UsersController < ApplicationController

  before_action :authenticate_user!

  # def show
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
    # @user = User.find(params[:id])
    # @user.update(user_params)
    # redirect_to root_path
  # end

  def profile
  end

  private

  # def user_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :picture)
  # end

end
