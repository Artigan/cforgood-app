class SubscribeToNewsletterBusiness
  def initialize(business)
    @business = business
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @list_id = ENV['MAILCHIMP_LIST_BUSINESS']
  end

  def run
    @gibbon.lists(@list_id).members.create(
      body: {
        email_address: @business.email,
        status: "subscribed",
        merge_fields: {
          NAME: @business.name,
          CITY: @business.city
        }
      }
    )
  end
end
