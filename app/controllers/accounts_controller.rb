class AccountsController < ApplicationController

  before_action :authenticate_user!

  def create
    wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id
    if !wallet_id
      wallet_id = ENV['MANGOPAY_CFORGOOD_WALLET_ID']
    end
    current_user.update_user!("card_id", params[:card][:id])
    if current_user.should_payin?
      current_user.create_mangopay_payin!(wallet_id)
    end
    redirect_to dashboard_path
  end

  private

  def card_params
    params.require(:card).permit(:id)
  end

end
