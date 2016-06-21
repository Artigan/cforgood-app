class MonthlyPayinJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "MONTHLY PAYIN JOB"
    puts "-----------------------------------------"
    puts ""

    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])

    puts "-----------------------------------------"
    puts "MEMBER ON TRIAL J-7"
    puts "-----------------------------------------"

    @user_trial_J_7 = User.member_on_trial_should_payin(7)
    nb_events_trial_J_7 = 0

    @user_trial_J_7.each do |user|
      if !user.card_id.present?
        begin
          intercom.events.create(
            event_name: "TRIAL-J-7",
            created_at: Time.now.to_i,
            user_id: user.id,
            email: user.email
          )
        rescue Intercom::ResourceNotFound
        end
        nb_events_trial_J_7 += 1
      end
    end

    puts ""
    puts "Nb user on trial J-7 : #{@user_trial_J_7.count}"
    puts "Nb event for trial J-7 : #{nb_events_trial_J_7}"
    puts "-----------------------------------------"
    puts ""


    puts "-----------------------------------------"
    puts "MEMBER ON TRIAL J-3"
    puts "-----------------------------------------"

    @user_trial_J_3 = User.member_on_trial_should_payin(3)
    nb_events_trial_J_3 = 0

    @user_trial_J_3.each do |user|
      if !user.card_id.present?
        begin
          intercom.events.create(
            event_name: "TRIAL-J-3",
            created_at: Time.now.to_i,
            user_id: user.id,
            email: user.email
          )
        rescue Intercom::ResourceNotFound
        end
        nb_events_trial_J_3 += 1
      end
    end

    puts ""
    puts "Nb user on trial J-3 : #{@user_trial_J_3.count}"
    puts "Nb event for trial J-3 : #{nb_events_trial_J_3}"
    puts "-----------------------------------------"
    puts ""

    puts "-----------------------------------------"
    puts "MEMBER ON TRIAL J-0"
    puts "-----------------------------------------"

    @user_trial_J_0 = User.member_on_trial_should_payin(0)
    nb_payin_trial_OK = 0
    nb_payin_trial_KO = 0
    nb_events_trial_J_0 = 0

    @user_trial_J_0.each do |user|
      if user.card_id.present?
        if monthly_payin(user)
          nb_payin_trial_OK += 1
        else
          nb_payin_trial_KO += 1
        end
      else
        begin
          intercom.events.create(
            event_name: "TRIAL-J-0",
            created_at: Time.now.to_i,
            user_id: user.id,
            email: user.email
          )
        rescue Intercom::ResourceNotFound
        end
        nb_events_trial_J_0 += 1
      end
    end

    puts ""
    puts "Nb user on trial J-0 : #{@user_trial_J_0.count}"
    puts "Nb payin OK trial J-0 : #{nb_payin_trial_OK}"
    puts "Nb payin KO trial J-0 : #{nb_payin_trial_KO}"
    puts "Nb event for trial J-0 : #{nb_events_trial_J_0}"
    puts "-----------------------------------------"
    puts ""

    # puts "-----------------------------------------"
    # puts "MONTHLY MEMBER"
    # puts "-----------------------------------------"

    # @user_member_should_payin = User.member_should_payin
    # nb_member_payin_OK = 0
    # nb_member_payin_KO = 0

    # @user_member_should_payin.each do |user|
    #   if monthly_payin(user)
    #     nb_member_payin_OK += 1
    #   else
    #     nb_member_payin_KO += 1
    #   end
    # end

    # puts "Nb member should payin : " + @user_member_should_payin.count
    # puts "Nb payin OK trial J-0 : " + nb_member_payin_OK
    # puts "Nb payin KO trial J-0 : " + nb_member_payin_KO
    # puts "-----------------------------------------"
    # puts ""

  end

  private

  def monthly_payin(user)
    wallet_id = Cause.find_by_id(user.cause_id).wallet_id if user.cause_id
    wallet_id = ENV['MANGOPAY_CFORGOOD_WALLET_ID'] unless wallet_id
    result = MangopayServices.new(user).create_mangopay_payin(wallet_id)
    binding.pry
    @payment = user.payments.new(cause_id: user.cause_id, amount: user.amount, done: result["ResultMessage"] == "Success" ? true : false)
    @payment.save

    if @payment.done
      user.update_attribute("date_last_payment", Time.now)
      return true
    else
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        intercom.events.create(
          event_name: "ERROR-PAYMENT",
          created_at: Time.now.to_i,
          user_id: user.id,
          email: user.email
        )
      rescue Intercom::ResourceNotFound
      end
      return false
    end
  end

 end
