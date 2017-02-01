class ImportUsers < ApplicationJob
  require 'csv'
  queue_as :default

  def perform
    csv_path = 'data/import_users.csv'
    ko, ok = 0, 0

    CSV.foreach(csv_path, { headers: :first_row, header_converters: :symbol }) do |row|

      begin
        User.find(row[:supervisor_id])
        row[:supervisor_id] = row[:supervisor_id].to_i
        # password automatique de devise
        # TODO: s'assurer que l'utilisateur recoit un email pour changer de mdp
        # ou set choisir un mdp 
        row[:password] = Devise.friendly_token.first(8)
        User.create!(row.to_h)
        ok += 1
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
        ko += 1
      end
    end

    puts "=========== RAPPORT =========="
    puts "#{ok} creations"
    puts "#{ko} échecs"
    puts "=============================="

  end
end
