class ExtractAmountCause < ApplicationJob

  require "stripe"

  queue_as :default

  def perform

    report = []
    report << "-----------------------------------------"

    Cause.all.each do |cause|

      begin
        result_mgp = MangoPay::Wallet.fetch(cause.wallet_id)
      rescue MangoPay::ResponseError => e
        puts e.message
      end

      if cause.acct_id
        begin
          result_stripe = Stripe::Balance.retrieve({:stripe_account => cause.acct_id})
        rescue Stripe::StripeError => e
          puts e
        end
      end

      report << "#{cause.id} | #{cause.name} | #{result_mgp.present? ? result_mgp["Balance"]["Amount"]/100.00 : 0.0} | #{result_stripe.present? ? result_stripe["available"].first["amount"]/100.00 : 0.0} | #{result_stripe.present? ? result_stripe["pending"].first["amount"]/100.00 : 0.0}"
    end

    report << "-----------------------------------------"

    # Report : Edit + Send to slack
    puts "-----------------------------------------"
    puts "Report EXTRACT AMOUNT CAUSE"
    puts "-----------------------------------------"
    puts "Id | Name | Mangopay | Stripe Available | Stripe Pending"

    fields = []
    report.each do |line|
      puts line
      fields << { "value": line }
    end

    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_JOB_URL']
      attachment = {
        fallback: "Report EXTRACT AMOUNT CAUSE JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report EXTRACT AMOUNT CAUSE JOB", attachments: [attachment]
    end

  end

end
