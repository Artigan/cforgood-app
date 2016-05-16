class DailyControlFlashJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "DAILY CONTROL FLASH JOB"
    puts "-----------------------------------------"

    @perks = Perk.active.where('flash = ? and end_date < ?', true, Time.now)

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
