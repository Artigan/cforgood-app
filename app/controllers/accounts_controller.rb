class AccountsController < ApplicationController

  before_action :authenticate_user!

  def create
    if current_user.cause_id
      wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id
    else
      wallet_id = Cause.find_by_name("CforGood").wallet_id
    end
    current_user.update_mangopay_card_id!(params[:card][:id])
    current_user.create_mangopay_payin!(wallet_id)
    redirect_to dashboard_path, notice: "Votre carte a bien été enregistrée"
  end

  private

  def card_params
    params.require(:card).permit(:id)
  end

end
