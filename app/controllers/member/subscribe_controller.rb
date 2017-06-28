class Member::SubscribeController < ApplicationController

  before_action :authenticate_user!

  def new
    @partner = Partner.find_by_code_partner(current_user.code_partner.upcase) if current_user.code_partner.present?
    if @partner && @partner.supervisor_id.present?
      @causes = Cause.active.where(supervisor_id: @partner.supervisor_id).includes(:cause_category)
    else
      @causes = Cause.active.all.includes(:cause_category)
    end
  end

  def create
    execute_payin(params)
    respond_to :js
  end

  def update
    if current_user.update_without_password(user_params)
      execute_payin(params)
    end
    respond_to :js
  end

  def destroy
    if current_user.user_histories.last.code_partner == current_user.code_partner
      current_user.user_histories.last.delete
      current_user.code_partner = nil
      current_user.date_end_partner = nil
      current_user.save
      current_user.user_histories.last.delete
    end
    respond_to :js
  end

  def gift
  end

  private

  def execute_payin(params)

    # No payment for gift
    if request.referer.include?('gift')
      if !current_user.member
        current_user.code_partner = "SIGNUPGIFT"
        current_user.member!
      end
      return
    end

    new_card = new_cause = new_subscription = false
    new_card = true if params[:stripeToken].present?
    new_cause = true if current_user.user_histories.last(2).first.cause_id != current_user.cause_id
    new_subscription = true if current_user.user_histories.last(2).first.subscription != current_user.subscription || current_user.user_histories.last(2).first.amount != current_user.amount || current_user.user_histories.last(2).first.code_partner != current_user.code_partner

    if !current_user.customer_id.present? && !new_card
      return
    end

    if new_card

      # Create Stripe customer on platform account
      if !current_user.customer_id.present?
        customer = StripeServices.new(user: current_user).create_customer(params[:stripeToken])
      else
        customer = StripeServices.new(user: current_user).update_customer(params[:stripeToken])
      end

      if customer.try(:id)
        current_user.update_attributes(customer_id: customer.id, card_id: customer.default_source)
      else
        manage_error(customer)
        return
      end

    end

    # Create Stripe customer on connected account or update if card or cause change
    if new_card || new_cause

      # Create token for customer to connected account
      if !current_user.shared_customer_id.present?
        shared_customer = StripeServices.new(user: current_user).create_shared_customer
      else
        shared_customer = StripeServices.new(user: current_user).update_shared_customer
      end

      if shared_customer.try(:id)
        current_user.update_attributes(shared_customer_id: shared_customer.id)
      else
        manage_error(share_customer)
        return
      end

    end

    # Create Stripe subscription or/and plans or update if subscription or amount or cause change or new user
    if new_card || new_cause || new_subscription

      plan_id = current_user.subscription == "M" ? "#{current_user.amount}-monthly" : "#{current_user.amount}-yearly"
      plan = StripeServices.new(user: current_user).retrieve_plan(plan_id)

      debited_funds = current_user.amount*100
      percent_asso =  SetDonation.new(current_user.amount.to_f, current_user.subscription).set_donation
      fees = (100 - percent_asso).round(2)

      # create plan
      plan = StripeServices.new(user: current_user).create_plan(plan_id, debited_funds) if !plan.try(:id)

      # create subscription
      if !current_user.subscription_id.present? || new_cause
        subscription = StripeServices.new(user: current_user).create_subscription(plan_id, fees)
      else
        subscription = StripeServices.new(user: current_user).update_subscription(plan_id, fees)
      end

      if subscription.try(:id)
        current_user.update_attributes(subscription_id: subscription.id, plan_id: plan_id)
      else
        manage_error(subscription)
        return
      end

    end

    # change bank details
    current_user.member!
    flash[:success] = "Vos coordonnées bancaires ont bien été prises en compte."
  end

  def card_params
    params.require(:card).permit(:id)
  end

  def user_params
    params.require(:user).permit(:subscription, :amount, :code_partner)
  end

  def stripe_params
    params.permit :stripeToken
  end

  def manage_error(error)
    flash[:error] = "Une erreur technique est survenue lors de l'enregistrement de vos données bancaires"
    puts "Stripe Error: #{error.message}"
    message = current_user.find_name_or_email + " : *erreur lors du paiement* : " + (error.message || "")
    send_message_to_slack(ENV['SLACK_WEBHOOK_USER_URL'], message)
    create_event_intercom
  end

  def create_event_intercom
    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
    begin
      intercom.events.create(
        event_name: "ERROR-PAYMENT-SUBSCRIPTION",
        created_at: Time.now.to_i,
        user_id: current_user.id,
        email: current_user.email
      )
    rescue Intercom::IntercomError => e
      puts e
    end
  end
end
