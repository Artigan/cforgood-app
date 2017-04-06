class UpdatePerks < ApplicationJob
  require 'csv'
  require 'net/ftp'
  queue_as :default

  def perform(ftp_file)
    # il faut prendre le fichier depuis le ftp
    ftp_path = 'datas/perk'
    report = []
    report << "-----------------------------------------"
    report << "Report UPDATE PERKS JOB"
    report << "-----------------------------------------"

    begin
      ftp = Net::FTP.new(ENV['FTP_URL'])
      ftp.login(ENV['FTP_LOGIN'], ENV['FTP_PASSWORD'])
      ftp.chdir(ftp_path)
      ftp.passive = true
      fileList= ftp.nlst
      ftp.gettextfile(ftp_file, csv_file = File.basename(ftp_file))
      ftp.close
    rescue Exception => e
      report << "ERROR FTP | #{e} |"
    end

    nb_update_ko, nb_update_ok, nb_read = 0, 0, 0

    CSV.foreach(csv_file, { headers: true, header_converters: :symbol, col_sep: ';' }) do |row|

      nb_read += 1
      # update user
      begin
        @perk = Perk.find(row[:id])
      rescue ActiveRecord::RecordNotFound
        nb_update_ko += 1
        report << "ERROR | #{row["Id"]} not found"
        next
      end
      @perk.offer = row[:offer]
      @perk.value = row[:value]
      @perk.percent = row[:percent]
      @perk.amount = row[:amount]
      if @perk.save
        nb_update_ok += 1
      else
        nb_update_ko += 1
        report << "ERROR | #{row["Id"]} not updated | #{@perk.errors.full_messages}"
      end
    end

    report << "-----------------------------------------"
    report << "Nb user read : #{nb_read}"
    report << "Nb user create OK : #{nb_update_ok}"
    report << "Nb user create KO : #{nb_update_ko}"
    report << "-----------------------------------------"

    # Edit report + Send to slack
    fields = []
    report.each do |line|
      puts line
      fields << { "value": line }
    end

    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_JOB_URL']
      attachment = {
        fallback: "Report UPDATE PERKS JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report UPDATE PERKS JOB", attachments: [attachment]
    end

  end
end
