class SetDonation
  def initialize(amount, subscription)
    @amount = amount
    @subscription = subscription
  end

  def set_donation
    if @subscription == "M"
      if @amount <= 5
        percent_asso = ((50-30)*((@amount-1)/(5.0-1.0)))+30
      elsif @amount <= 10
        percent_asso = ((70-50)*((@amount-5)/(10.0-5.0)))+50
      elsif @amount <= 15
        percent_asso = ((75-70)*((@amount-10)/(15.0-10.0)))+70
      elsif @amount <= 20
        percent_asso = ((77.5-75)*((@amount-15)/(20.0-15.0)))+75
      elsif @amount <= 25
        percent_asso = ((80-77.5)*((@amount-20)/(25.0-20.0)))+77.5
      elsif @amount <= 50
        percent_asso = (((85-80)*((@amount-25)/(50.0-25.0)))+80)
      end
    else
      if @amount <= 50
        percent_asso = ((50-30.0)*((@amount-30)/(50-30)))+30
      elsif (@amount <= 100)
        percent_asso = ((70-50.0)*((@amount-50)/(100-50)))+50
      elsif (@amount <= 150)
        percent_asso = ((75-70.0)*((@amount-100)/(150-100)))+70
      elsif (@amount <= 200)
        percent_asso = ((77.5-75)*((@amount-150)/(200-150)))+75
      elsif (@amount <= 250)
        percent_asso = ((80-77.5)*((@amount-200)/(250-200)))+77.5
      else
        percent_asso = ((85-80.0)*((@amount-250)/(500-250)))+80
      end
    end

    return @amount*percent_asso/100
  end
end
