class StripeServices

  # def initialize()
  #     @user = user
  #     @acct_id = user.cause.acct_id if user
  # end
  include Modules::ModuleSlack

  def initialize(options = {})
    @user = options[:user] ||= nil
    @acct_id = options[:acct_id] ||= @user.present? ? @user.cause.acct_id : nil
    @old_acct_id = options[:old_acct_id] ||= nil
  end

  def create_account(cause)

    account_info = {
      type: 'custom',
      country: 'FR',
      email: cause.email,
      business_name: cause.name
    }

    stripe_account_create(account_info)
  end

  def create_customer(stripe_token)

    customer_info = {
      email: @user.email,
      description: @user.first_name.capitalize + " " + @user.last_name.capitalize,
      source: stripe_token
    }

    stripe_customer_create(customer_info)
  end

  def update_customer(stripe_token)

    customer = stripe_customer_retrieve(@user.customer_id)

    if customer.try(:id)
      customer.sources.retrieve(@user.card_id).delete() if @user.card_id.present?
      customer.sources.create(source: stripe_token)
      customer.save
    end
  end

  def retrieve_customer
    customer = stripe_customer_retrieve(@user.customer_id)
  end

  def create_shared_customer

    token_info = {
      customer: @user.customer_id,
    }

    token = stripe_token_create(token_info, @acct_id)

    if token.try(:id)
      shared_customer_info = {
        email: @user.email,
        description: @user.first_name.capitalize + " " + @user.last_name.capitalize,
        source: token.id
      }

      shared_customer = stripe_shared_customer_create(shared_customer_info, @acct_id)

      # save shared_customer id in metadata of customer on platform account
      if shared_customer.try(:id)
        customer = stripe_customer_retrieve(@user.customer_id)
        if customer.try(:id)
          customer.metadata[@acct_id] = shared_customer.id
          customer.save
        end
      end

    end
    return shared_customer
  end

  def update_shared_customer

    token_info = {
      customer: @user.customer_id,
    }

    token = stripe_token_create(token_info, @acct_id)

    if token.try(:id)

      shared_customer = stripe_shared_customer_retrieve(@user.shared_customer_id, @acct_id)

      if shared_customer.try(:id)
        shared_customer.sources.retrieve(shared_customer.sources.data[0].id).delete() if shared_customer.sources.data[0].id.present?
        shared_customer.sources.create(source: token.id)
        shared_customer.save
        return shared_customer
      end
    end
  end

  def retrieve_plan(plan_id)
    stripe_plan_retrieve(plan_id, @acct_id)
  end

  def create_plan(plan_id, debited_funds)

    plan_info = {
      name: "Plan #{plan_id}",
      id: plan_id,
      interval: @user.subscription == "M" ? "month" : "year",
      currency: "eur",
      amount: debited_funds,
      statement_descriptor: "CforGood"
    }

    stripe_plan_create(plan_info, @acct_id)
  end

  def create_subscription(plan_id, fees)

    subscription_info = {
      customer:  @user.shared_customer_id,
      plan: plan_id,
      application_fee_percent: fees,
      trial_end: @user.date_end_partner.present? ? @user.date_end_partner.to_time.to_i : nil
    }

    stripe_subscription_create(subscription_info, @acct_id)
  end

  def duplicate_subscription(customer_id, plan_id, subscription)

    subscription_info = {
      customer:  customer_id,
      plan: plan_id,
      application_fee_percent: subscription.application_fee_percent,
      current_period_end: subscription.current_period_end,
      current_period_start: subscription.current_period_start,
      trial_end: subscription.trial_end,
      trial_start: subscription.trial_start
    }

    stripe_subscription_create(subscription_info, @acct_id)
  end

  def update_subscription(plan_id, fees)
    subscription = stripe_subscription_retrieve(@user.subscription_id, @acct_id)
    if subscription.try(:id)
      subscription.plan = plan_id
      subscription.application_fee_percent = fees
      subscription.trial_end = @user.date_end_partner.to_time.to_i if @user.date_end_partner.present?
      subscription.prorate = false
      subscription.save
      return subscription
    end
  end

  def retrieve_subscription
    stripe_subscription_retrieve(@user.subcription_id, @acct_id)
  end

  def delete_subscription
    subscription = stripe_subscription_retrieve(@user.subscription_id, @acct_id)
    if subscription.try(:id)
      subscription.delete
    end
  end

  def change_connected_account

    customer = stripe_customer_retrieve(@user.customer_id)

    return if !customer.try(:id)

    binding.pry
    #  control if shared customer already exist for new cause
    shared_customer_id = customer.metadata[@acct_id]
    if !shared_customer_id.present?
      shared_customer = create_shared_customer
    else
      shared_customer = update_shared_customer
    end

    if shared_customer.try(:id)
      # @user.shared_customer_id = shared_customer.id
    else
      # flash[:error] = "Une erreur technique est survenue lors de l'enregistrement de vos données bancaires"
      error = shared_customer
      puts "Stripe Error: #{error.message}"
      message = @user.find_name_or_email + ": *Stripe : erreur lors du changement d'association* :" + (error.message || "")
      send_message_to_slack(ENV['SLACK_WEBHOOK_USER_URL'], message)
      return
    end

    plan_id = @user.subscription == "M" ? "#{@user.amount}-monthly" : "#{@user.amount}-yearly"
    plan = stripe_plan_retrieve(plan_id, @acct_id)

    debited_funds = @user.amount*100
    # create plan
    plan = create_plan(plan_id, debited_funds) if !plan.try(:id)

    # retrieve old subscription
    old_subscription = stripe_subscription_retrieve(@user.subscription_id, @old_acct_id)

    binding.pry
    # duplicate subscription
    subscription = duplicate_subscription(shared_customer.id, plan_id, old_subscription) if old_subscription.try(:id)

    if subscription.try(:id)
      old_subscription.delete if old_subscription.try(:id)
      # @user.subscription_id = subscription.id
    else
      # flash[:error] = "Une erreur technique est survenue lors de la création de votre abonnement"
      error = subscription || old_subscription
      puts "Stripe Error: #{error.message}"
      message = @user.find_name_or_email + ": *Stripe : erreur lors du changement d'association* :" + (error.message || "")
      send_message_to_slack(ENV['SLACK_WEBHOOK_USER_URL'], message)
    end
  end

  private

  def stripe_account_create(account_info)
    begin
      Stripe::Account.create(account_info)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_customer_create(customer_info)
    begin
      Stripe::Customer.create(customer_info)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_customer_retrieve(customer_id)
    begin
      Stripe::Customer.retrieve(customer_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_shared_customer_create(customer_info, acct_id)
    begin
      Stripe::Customer.create(customer_info, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_shared_customer_retrieve(customer_id, acct_id)
    begin
      Stripe::Customer.retrieve(customer_id, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_token_create(token_info, acct_id)
    begin
      Stripe::Token.create(token_info, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_plan_retrieve(plan_id, acct_id)
    begin
      Stripe::Plan.retrieve(plan_id, stripe_account: acct_id)
    rescue Stripe::InvalidRequestError =>  e
      return e
    end
  end

  def stripe_plan_create(plan_info, acct_id)
    begin
      Stripe::Plan.create(plan_info, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_subscription_create(subscription_info, acct_id)
    begin
      Stripe::Subscription.create(subscription_info, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end

  def stripe_subscription_retrieve(subscription_id, acct_id)
    begin
      Stripe::Subscription.retrieve(subscription_id, stripe_account: acct_id)
    rescue Stripe::StripeError => e
      return e
    end
  end
end

