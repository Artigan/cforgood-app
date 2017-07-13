class StripeServices

  include Modules::ModuleSlack

  def initialize(options = {})
    @user = options[:user] ||= nil
    @acct_id = options[:acct_id] ||= @user.present? ? @user.cause.acct_id : nil
    @old_acct_id = options[:old_acct_id] ||= nil
    @params = options[:params] ||= nil
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

  def update_account(cause)

    account = stripe_account_retrieve(cause.acct_id)

    return account if !account.try(:id)

    account.legal_entity.type = 'company'
    account.legal_entity.address.line1 = cause.street if cause.street.present?
    account.legal_entity.address.postal_code = cause.zipcode if cause.zipcode.present?
    account.legal_entity.address.city = cause.city if cause.city.present?
    account.legal_entity.first_name = cause.representative_first_name if cause.representative_first_name.present?
    account.legal_entity.last_name = cause.representative_last_name if cause.representative_last_name.present?
    account.legal_entity.dob.day = cause.representative_birthday.try(:day) if cause.representative_birthday.present?
    account.legal_entity.dob.month = cause.representative_birthday.try(:month) if cause.representative_birthday.present?
    account.legal_entity.dob.year = cause.representative_birthday.try(:year) if cause.representative_birthday.present?
    account.save
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
      customer.sources.retrieve(@user.card_id).delete() if @user.card_id.present? && customer.sources.data[0].present?
      source = stripe_source_create(customer, stripe_token)
      if source.try(:id)
        customer.save
      else
        return source
      end
      return customer
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
        shared_customer.sources.retrieve(shared_customer.sources.data[0].id).delete() if shared_customer.sources.data[0].try(:id).present?
        shared_customer.sources.create(source: token.id)
        shared_customer.save
      end
      return shared_customer
    end
    return token
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
    stripe_subscription_retrieve(@user.subscription_id, @acct_id)
  end

  def duplicate_subscription(customer_id, plan_id, subscription)
    subscription_info = {
      customer:  customer_id,
      plan: plan_id,
      application_fee_percent: subscription.application_fee_percent,
      trial_end: subscription.current_period_end
    }

    stripe_subscription_create(subscription_info, @acct_id)
  end

  def delete_subscription
    subscription = stripe_subscription_retrieve(@user.subscription_id, @acct_id)
    if subscription.try(:id)
      subscription.delete
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

  def stripe_account_retrieve(account_id)
    begin
      Stripe::Account.retrieve(account_id)
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

  def stripe_source_create(customer, stripe_token)
    begin
      customer.sources.create(source: stripe_token)
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

