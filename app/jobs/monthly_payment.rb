class MonthlyPaymentJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "MONTHLY PAYMENT JOB"
    puts "-----------------------------------------"
    put  "TIME : " + Time.now


    # Extraire tous les membres dont la période d'essai est dépassée
    # => désactiver
    # => remonter évènement

    @user_trial_done = User.  where('')


    # Extraire members (member + date payment > 1 month  ) + (trial should_payin + card_id)
    # => payment
    #   si ok
    #   => mettre à jour la date de dernier payment
    #   => ajout payment
    #   sinon
    #   => envoyé un évènement d'erreur


    @user_member_should_payin = User.member_should_payin

    if @perks.present?
      puts "nb perks in: #{@perks.count}"
    else
      puts "nb perks in: 0"
    end
    puts "-----------------------------------------"

    nb_perk_inactivated = 0

    @perks.each do |perk|
      if perk.update(active: false)
        nb_perk_inactivated += 1
        puts "perk: #{perk.id} - business: #{perk.business.name} (#{perk.business_id}) - inactive"
      end
    end

    puts "-----------------------------------------"
    puts "nb perks updated: #{nb_perk_inactivated}"
    puts "-----------------------------------------"
  end
end
