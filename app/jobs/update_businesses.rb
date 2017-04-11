class UpdateBusinesses < ApplicationJob
  require 'csv'
  require 'net/ftp'
  queue_as :default

  def perform(ftp_file)
    # il faut prendre le fichier depuis le ftp
    ftp_path = 'datas/business'
    report = []
    report << "-----------------------------------------"
    report << "Report UPDATE BUSINESSES JOB"
    report << "-----------------------------------------"

    begin
      ftp = Net::FTP.new(ENV['FTP_URL'])
      ftp.login(ENV['FTP_LOGIN'], ENV['FTP_PASSWORD'])
      ftp.chdir(ftp_path)
      ftp.passive = true
      fileList= ftp.nlst
      ftp.getbinaryfile(ftp_file, csv_file = File.basename(ftp_file))
      ftp.close
    rescue Exception => e
      report << "ERROR FTP | #{e} |"
    end

    action_local = LabelCategory.where(name: "Action Locale").first.id
    circuit_court = LabelCategory.where(name: "Circuit Court").first.id
    engagement_social = LabelCategory.where(name: "Engagement social").first.id
    monnaie_locale = LabelCategory.where(name: "Monnaie Locale").first.id
    anti_gaspillage = LabelCategory.where(name: "Politique anti-gaspillage").first.id
    zero_dechet = LabelCategory.where(name: "Zéro déchet").first.id
    modele_collaboratif = LabelCategory.where(name: "Modèle collaboratif/participatif").first.id
    energies_renouvelables = LabelCategory.where(name: "Énergies renouvelables").first.id
    produits_eco_responables = LabelCategory.where(name: "Produits éco-responsables").first.id
    epannouissement_personnel = LabelCategory.where(name: "Épanouissement personnel").first.id
    animation_culturelle = LabelCategory.where(name: "Animation culturelle").first.id

    nb_update_ko, nb_update_ok, nb_read = 0, 0, 0

    CSV.foreach(csv_file, { headers: true, header_converters: :symbol, col_sep: ';' }) do |row|

      nb_read += 1
      # update business
      begin
        @business = Business.find(row[:id])
      rescue ActiveRecord::RecordNotFound
        nb_update_ko += 1
        report << "ERROR | #{row["Id"]} not found"
        next
      end

      # @business.name = @business.name if @business.name != @business.name
      @business.name = row[:name] if row[:name]
      @business.activity = row[:activity] if row[:activity]
      @business.labels.build(label_category_id: action_local).save if row[:action_local] == "1"
      @business.labels.build(label_category_id: circuit_court).save if row[:circuit_court] == "1"
      @business.labels.build(label_category_id: engagement_social).save if row[:engagement_social] == "1"
      @business.labels.build(label_category_id: monnaie_locale).save if row[:monnaie_locale] == "1"
      @business.labels.build(label_category_id: anti_gaspillage).save if row[:anti_gaspillage] == "1"
      @business.labels.build(label_category_id: zero_dechet).save if row[:zero_dechet] == "1"
      @business.labels.build(label_category_id: modele_collaboratif).save if row[:modele_collaboratif] == "1"
      @business.labels.build(label_category_id: energies_renouvelables).save if row[:energies_renouvelables] == "1"
      @business.labels.build(label_category_id: produits_eco_responables).save if row[:produits_eco_responables] == "1"
      @business.labels.build(label_category_id: epannouissement_personnel).save if row[:epannouissement_personnel] == "1"
      @business.labels.build(label_category_id: animation_culturelle).save if row[:animation_culturelle] == "1"

      if @business.save
        nb_update_ok += 1
      else
        nb_update_ko += 1
        report << "ERROR | #{row["Id"]} not updated | #{@business.errors.full_messages}"
      end
    end

    report << "-----------------------------------------"
    report << "Nb business read : #{nb_read}"
    report << "Nb business update OK : #{nb_update_ok}"
    report << "Nb business update KO : #{nb_update_ko}"
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
        fallback: "Report UPDATE BUSINESSES JOB",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report UPDATE BUSINESSES JOB", attachments: [attachment]
    end

  end
end
