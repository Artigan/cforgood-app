class ExtractUsersJob < ApplicationJob

  require 'csv'
  require 'open-uri'
  require 'net/ftp'
  queue_as :default

  def perform(date, separator_char)

    separator =  separator_char || "|"
    date_from =  date || "20000101"

    path = "tmp/"
    filename = 'user_' + Time.now.strftime("%Y%m%d_%H%M%S") + '.csv'

    report = []
    report << "-----------------------------------------"

    nb_users_read = 0

    users = []

    CSV.open(path + filename, "wb", :col_sep => '|') do |csv|
      csv << [
        "id",
        "email",
        "current_sign_in_at",
        "last_sign_in_at",
        "created_at",
        "first_name",
        "last_name",
        "country_of_residence",
        "cause_id",
        "member",
        "subscription",
        "trial_done",
        "date_subscription",
        "date_last_payment",
        "street",
        "zipcode",
        "city",
        "latitude",
        "longitude",
        "date_end_partner",
        "code_partner",
        "date_support",
        "amount",
        "date_stop_subscription",
        "ambassador",
        "ecosystem_id",
        "supervisor",
        "supervisor_id",
        "phone",
        "business_supervisor_id",
        "last_ecosystem_seen",
        "sponsorship_done"
      ]

      User.active.where("users.created_at > ?", date_from).each do |user|
        nb_users_read += 1
        row = [
          user.id,
          user.email,
          user.current_sign_in_at,
          user.last_sign_in_at,
          user.created_at,
          user.first_name,
          user.last_name,
          user.country_of_residence,
          user.cause_id,
          user.member,
          user.subscription,
          user.trial_done,
          user.date_subscription,
          user.date_last_payment,
          user.street,
          user.zipcode,
          user.city,
          user.latitude,
          user.longitude,
          user.date_end_partner,
          user.code_partner,
          user.date_support,
          user.amount,
          user.date_stop_subscription,
          user.ambassador,
          user.ecosystem_id,
          user.supervisor,
          user.supervisor_id,
          user.phone,
          user.business_supervisor_id,
          user.last_ecosystem_seen,
          user.sponsorship_done
        ]
        csv << row
      end
    end

    # Write file on FTP

    begin
      ftp = Net::FTP.new(ENV['FTP_URL'])
      ftp.login(ENV['FTP_LOGIN'], ENV['FTP_PASSWORD'])
      ftp.chdir("datas/user")
      ftp.passive = true
      ftp.puttextfile(path + filename, filename)
      ftp.close
    rescue Exception => e
      report << "ERROR FTP | #{e} |"
    end

    report << "Nb users read | #{nb_users_read}"
    report << "-----------------------------------------"

    # Edit report + Send to slack
    puts "-----------------------------------------"
    puts "Report EXTRACT USERS JOB"
    fields = []
    report.each do |line|
      puts line
      fields << { "value": line }
    end

    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_JOB_URL']
      attachment = {
        fallback: "Report EXTRACT USERS JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report EXTRACT USERS JOB", attachments: [attachment]
    end
  end
end
