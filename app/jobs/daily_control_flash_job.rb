class DailyControlFlashJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "DAILY CONTROL FLASH JOB"
    puts "-----------------------------------------"

    @perks = Perk.active.where('flash = ? and end_date < ?', true, Time.now)


    puts "Nb perks in | #{@perks.size}"
    puts "-----------------------------------------"

    nb_perk_inactivated = 0

    @perks.each do |perk|
      if perk.update(active: false)
        nb_perk_inactivated += 1
        puts "perk | #{perk.id} | business | #{perk.business_id} | #{perk.business.name} | inactive"
      end
    end

    puts "-----------------------------------------"
    puts "Nb perks updated | #{nb_perk_inactivated}"
    puts "-----------------------------------------"
  end
end
