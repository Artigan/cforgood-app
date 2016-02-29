class SubscribeToNewsletter
  def initialize(newsletter)
    @newsletter = newsletter
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @list_id = ENV['MAILCHIMP_LIST_NEWSLETTER']
  end

  def run
    begin
      @gibbon.lists(@list_id).members.create(
        body: {
          email_address: @newsletter[:email],
          status: "subscribed"
        }
      )
    rescue Gibbon::MailChimpError => exception
      # Rails.logger.error("Erreur lors de l'insciption #{exception.detail}")
      @newsletter.errors.add("Erreur lors de l'insciption #{exception.detail}")
    end
  end
end
