class SubscribeToNewsletterCause
  def initialize(cause)
    @cause = cause
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @list_id = ENV['MAILCHIMP_LIST_CAUSE']
  end

  def run
    pry-buebug
    @gibbon.lists(@list_id).members.create(
      body: {
        email_address: @cause.email,
        status: "subscribed",
        double_optin: false,
        merge_fields: {
          NAME: @cause.name,
          CITY: @cause.city
        }
      }
    )
  end
end
