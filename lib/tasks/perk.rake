namespace :perk do

  desc "Control flash in time"
  task daily_control_flash: :environment do
    puts "----------------------------------------"
    puts "TASK PERK_IN_TIME STARTING"
    puts "----------------------------------------"

    DailyControlFlashJob.perform_later

    puts "----------------------------------------"
    puts "TASK PERK_IN_TIME DONE"
    puts "----------------------------------------"
  end

end
