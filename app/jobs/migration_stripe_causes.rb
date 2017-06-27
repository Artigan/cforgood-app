class MigrationStripeCauses < ApplicationJob
  require "stripe"
  queue_as :default

  def perform

    report = []
    report << "-----------------------------------------"

    nb_causes_read = 0
    nb_causes_ok = 0
    nb_causes_ko = 0

    Cause.active.where(acct_id: nil).each do |cause|

      nb_causes_read += 1

      account = StripeServices.new().create_account(cause)

      if !account.try(:id)
        nb_causes_ko += 1
        report << "ERROR | #{cause.id} not created | #{account.message}"
        next
      end

      cause.update(acct_id: account.id)

      account = StripeServices.new().update_account(cause)

      if account.try(:id)
         nb_causes_ok += 1
      else
        nb_causes_ko += 1
        report << "ERROR | #{cause.id} not updated | #{account.message}"
      end

    end

    report << "-----------------------------------------"
    report << "Nb Causes lues | #{nb_causes_read}"
    report << "Nb Causes_OK | #{nb_causes_ok}"
    report << "Nb Causes_KO | #{nb_causes_ko}"
    report << "-----------------------------------------"

    # Edit report + Send to slack
    puts "-----------------------------------------"
    puts "Report Migration Causes Stripe JOB"
    fields = []
    report.each do |line|
      puts line
      fields << { "value": line }
    end

    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_JOB_URL']
      attachment = {
        fallback: "Report Migration Causes Stripe JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report Migration Causes Stripe JOB", attachments: [attachment]
    end

  end
end
