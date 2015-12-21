class AccountsController < ApplicationController

  before_action :authenticate_user!

  def create
    wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id
    if !wallet_id
      wallet_id = ENV['MANGOPAY_CLIENT_WALLET_ID']
    end
    current_user.update_user!("card_id", params[:card][:id])
    current_user.create_mangopay_payin!(wallet_id)
    current_user.update_user!("member", true)
    redirect_to dashboard_path, notice: "Votre carte a bien été enregistrée"
  end

  private

  def card_params
    params.require(:card).permit(:id)
  end

end
