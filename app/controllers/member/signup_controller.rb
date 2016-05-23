class Member::SignupController < ApplicationController

  before_action :authenticate_user!

  def create
    if current_user.mangopay_id
      current_user.update_attribute("card_id", params[:card][:id])
      if current_user.should_payin?
        wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id if current_user.cause_id
        wallet_id = ENV['MANGOPAY_CFORGOOD_WALLET_ID'] unless wallet_id
        result = MangopayServices.new(current_user).create_mangopay_payin(wallet_id)
        if result["ResultMessage"] == "Success"
          @payment = current_user.payments.new(cause_id: current_user.cause_id, amount: current_user.amount)
          if @payment.save
            current_user.member!
            current_user.update_attribute("date_last_payment", Time.now)
            flash[:success] = "Vos données bancaires ont bien été enregistrées"
          else
            flash[:alert] = "Erreur lors de l'enregistrement de votre paiement"
          end
        else
          flash[:alert] = result["ResultMessage"]
        end
      end
    end
    redirect_to member_user_dashboard_path(current_user)
  end

  private

  def card_params
    params.require(:card).permit(:id)
  end
end
