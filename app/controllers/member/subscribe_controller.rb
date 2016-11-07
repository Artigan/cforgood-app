class Member::SubscribeController < ApplicationController

  before_action :authenticate_user!


  def new
    @cause = Cause.all.includes(:cause_category)
  end

  def create
    if current_user.mangopay_id
      current_user.update_attribute("card_id", params[:card][:id])
      execute_payin
    end
    respond_to :js
  end

  def update
    if current_user.update_without_password(user_params)
      if current_user.card_id
        execute_payin
      end
    end
  end

  private

  def execute_payin
    binding.pry
    if current_user.should_payin? || ( params['commit'] == "M'abonner" && current_user.code_partner.present? )
      wallet_id = Cause.find_by_id(current_user.cause_id).wallet_id if current_user.cause_id
      wallet_id = ENV['MANGOPAY_CFORGOOD_WALLET_ID'] unless wallet_id
      result = MangopayServices.new(current_user).create_mangopay_payin(wallet_id)
      if result["ResultMessage"] == "Success"
        @payment = current_user.payments.new(cause_id: current_user.cause_id, amount: current_user.amount, done: true)
        if @payment.save
          current_user.member!
          current_user.update(date_last_payment: Time.now, code_partner: nil, date_end_partner: nil)
          flash[:success] = "Votre paiement a été pris en compte."
        else
          flash[:alert] = "Erreur lors de l'enregistrement de votre paiement."
        end
      else
        flash[:alert] = result["ResultMessage"]
        if Rails.env.production?
          notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_USER_URL']
          if current_user.last_name.present?
            message = "#{current_user.first_name} #{current_user.last_name}"
          elsif name.present?
            message = "#{current_user.name}"
          else
            message = "#{current_user.email}"
          end
          message = message + ": *erreur lors du paiement* :" + result["ResultMessage"]
          notifier.ping message
        end
      end
    elsif current_user.subscription.present?
      flash[:success] = "Vos données bancaires ont bien été enregistrées."
      current_user.member!
    end
  end

  def card_params
    params.require(:card).permit(:id)
  end

  def user_params
    params.require(:user).permit(:subscription, :amount, :code_partner)
  end
end
