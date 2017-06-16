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
      puts e.message
      return
    rescue Exception => e
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end

    render :json => {:status => 200}
  end

end
