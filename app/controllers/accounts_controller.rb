class AccountsController < ApplicationController

  before_action :authenticate_user!

  def new
    if no_wallet_id?
      redirect_to edit_user_registration_path, alert: "Vous devez tout d'abord choisir un bénéficiaire pour vos dons"
    end
  end

  def create
    wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id
    current_user.update_mangopay_card_id!(params[:card][:id])
    current_user.create_mangopay_payin!(wallet_id)
    redirect_to dashboard_path, notice: "Votre carte a bien été enregistrée"
  end

  private

  def card_params
    params.require(:card).permit(:id)
  end

  def no_wallet_id?
    Cause.where(id: current_user.cause_id).where.not(wallet_id: nil).empty?
  end

end
