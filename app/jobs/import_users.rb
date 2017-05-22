class ImportUsers < ApplicationJob
  require 'csv'
  require 'net/ftp'
  queue_as :default

  def perform(ftp_file)
    # il faut prendre le fichier depuis le ftp
    ftp_path = 'datas/user'
    report = []
    report << "-----------------------------------------"
    report << "Report IMPORT USERS JOB"
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

    ko, ok, nb_read = 0, 0, 0

    CSV.foreach(csv_file, { headers: true, header_converters: :symbol, col_sep: ';' }) do |row|

      nb_read += 1

      begin
        @supervisor = User.find(row[:supervisor_id].to_i)
        if !@supervisor.supervisor
          ko += 1
          report << "ERROR User create | #{row[:email]} | Supervisor is not a supervisor"
          next
        end
        # password automatique de devise
        # TODO: s'assurer que l'utilisateur recoit un email pour changer de mdp
        # ou set choisir un mdp
        row[:password] = "cforgood"
        # row[:password] = Devise.friendly_token.first(8)
        @employee = User.create!(row.to_h)
        ok += 1
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
        ko += 1
        report << "ERROR User create | #{row[:email]} | #{e} "
      end
    end

    report << "-----------------------------------------"
    report << "Nb user read : #{nb_read}"
    report << "Nb user create OK : #{ok}"
    report << "Nb user create KO : #{ko}"
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
        fallback: "Report IMPORT USERS JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report IMPORT USERS JOB", attachments: [attachment]
    end

  end
end
