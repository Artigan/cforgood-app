class StripeController < ApplicationController

  protect_from_forgery except: [:webhook]
  skip_before_action :authenticate_user!

  def webhook

    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      #refer event types here https://stripe.com/docs/api#event_types
      case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'charge.failed'
          handle_failure_charge event_object
        when 'customer.subscription.deleted'
        when 'customer.subscription.updated'
      end
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render :json => {:status => 400, :error => e.message}
      return
    rescue Exception => e
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end

    render :json => {:status => 200}
  end

  private

  def handle_success_invoice(event_object)
    @user = User.find_by_subscription_id(event_object["lines"]["data"][0]["id"])
    @payment = @user.paymentsnew(cause_id: @user.cause_id, amount: @user.amount, subscription: @user.subscription, done: true) if @user
    if @payment.save
      @user.update(date_last_payment: Time.now, code_partner: nil, date_end_partner: nil)
    else
      create_event_intercom(user)
    end
  end

  def handle_failure_invoice(event_object)
    @user = User.find_by_customer_id(event_object.id)
    @payment = @user.payments.new(cause_id: @user.cause_id, amount: @user.amount, subscription: @user.subscription, done: false) if @user
    if @payment.save
      create_event_intercom(user)
    end
  end


  def create_event_intercom(user)
    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
    begin
      intercom.events.create(
        event_name: "ERROR-PAYMENT-SUBSCRIPTION",
        created_at: Time.now.to_i,
        user_id: user.id,
        email: user.email
      )
    rescue Intercom::IntercomError => e
      puts e
    end
  end
end
