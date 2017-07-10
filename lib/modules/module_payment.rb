module Modules

  module ModulePayment

    def set_percent_cause(amount, subscription)
      if subscription == "M"
        if amount <= 5
          percent_cause = ((50-30)*((amount-1)/(5.0-1.0)))+30
        elsif amount <= 10
          percent_cause = ((70-50)*((amount-5)/(10.0-5.0)))+50
        elsif amount <= 15
          percent_cause = ((75-70)*((amount-10)/(15.0-10.0)))+70
        elsif amount <= 20
          percent_cause = ((77.5-75)*((amount-15)/(20.0-15.0)))+75
        elsif amount <= 25
          percent_cause = ((80-77.5)*((amount-20)/(25.0-20.0)))+77.5
        elsif amount <= 50
          percent_cause = (((85-80)*((amount-25)/(50.0-25.0)))+80)
        end
      else
        if amount <= 50
          percent_cause = ((50-30.0)*((amount-30)/(50-30)))+30
        elsif (amount <= 100)
          percent_cause = ((70-50.0)*((amount-50)/(100-50)))+50
        elsif (amount <= 150)
          percent_cause = ((75-70.0)*((amount-100)/(150-100)))+70
        elsif (amount <= 200)
          percent_cause = ((77.5-75)*((amount-150)/(200-150)))+75
        elsif (amount <= 250)
          percent_cause = ((80-77.5)*((amount-200)/(250-200)))+77.5
        else
          percent_cause = ((85-80.0)*((amount-250)/(500-250)))+80
        end
      end
    end

    def set_donation(amount, subscription)
      percent_cause = set_percent_cause(amount, subscription)
      return amount*percent_cause/100
    end

    def create_or_update_payment(current_user, params)

      new_card = new_cause = new_subscription = false
      new_card = true if params[:stripeToken].present?
      new_cause = true if current_user.user_histories.last(2).first.cause_id != current_user.cause_id
      new_subscription = true if current_user.user_histories.last(2).first.subscription != current_user.subscription || current_user.user_histories.last(2).first.amount != current_user.amount || current_user.user_histories.last(2).first.code_partner != current_user.code_partner

      if !current_user.customer_id.present? && !new_card
        return false
      end

      if new_card

        # Create Stripe customer on platform account
        if !current_user.customer_id.present?
          customer = StripeServices.new(user: current_user).create_customer(params[:stripeToken])
        else
          customer = StripeServices.new(user: current_user).update_customer(params[:stripeToken])
        end

        if customer.try(:id)
          current_user.update_attributes(customer_id: customer.id, card_id: customer.default_source, mangopay_id: nil, mangopay_card_id: nil)
        else
          manage_error(customer)
          return false
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
          manage_error(shared_customer)
          return false
        end

      end

      # Create Stripe subscription or/and plans or update if subscription or amount or cause change or new user
      if new_card || new_cause || new_subscription

        plan_id = current_user.subscription == "M" ? "#{current_user.amount}-monthly" : "#{current_user.amount}-yearly"
        plan = StripeServices.new(user: current_user).retrieve_plan(plan_id)

        # amount débited to customer
        debited_funds = current_user.amount*100.0
        # amount for CforGood
        percent_cause = set_percent_cause(current_user.amount.to_f, current_user.subscription)
        fees = (100 - percent_cause).round(2)

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
          return false
        end

      end

      # change bank details
      current_user.member!
      flash[:success] = "Vos coordonnées bancaires ont bien été prises en compte."
      return true
    end

    def manage_error(error)
      flash[:error] = "Une erreur technique est survenue lors de l'enregistrement de vos données bancaires"
      message = current_user.find_name_or_email + " : *erreur lors du paiement* : " + (error.message || "")
      send_message_to_slack(ENV['SLACK_WEBHOOK_PAYMENT_URL'], message)

      # create_event_intercom
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

end
