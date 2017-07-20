# == Schema Information
#
# Table name: causes
#
#  id                         :integer          not null, primary key
#  name                       :string
#  description                :text
#  street                     :string
#  zipcode                    :string
#  city                       :string
#  url                        :string
#  email                      :string
#  phone                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  impact                     :string
#  cause_category_id          :integer
#  facebook                   :string
#  twitter                    :string
#  instagram                  :string
#  description_impact         :string
#  latitude                   :float
#  longitude                  :float
#  mangopay_id                :string
#  wallet_id                  :string
#  representative_first_name  :string
#  representative_last_name   :string
#  amount_impact              :integer
#  active                     :boolean          default(FALSE), not null
#  link_video                 :string
#  picture                    :string
#  logo                       :string
#  like                       :integer          default(0)
#  unlike                     :integer          default(0)
#  mailing                    :boolean          default(TRUE)
#  tax_receipt                :boolean          default(TRUE)
#  followers                  :string
#  heard                      :string
#  supervisor_id              :integer
#  representative_testimonial :text
#  civility                   :integer
#  national                   :boolean          default(FALSE)
#  acct_id                    :string
#  representative_birthday    :datetime
#  acceptance_stripe          :boolean          default(FALSE), not null
#  bank_account_id            :string
#
# Indexes
#
#  index_causes_on_cause_category_id  (cause_category_id)
#  index_causes_on_supervisor_id      (supervisor_id)
#
# Foreign Keys
#
#  fk_rails_5f972e4f3f  (supervisor_id => businesses.id)
#

class Cause < ApplicationRecord
  belongs_to :cause_category
  has_many :users
  has_many :payments
  has_many :user_histories

  validates_size_of :picture, maximum: 2.megabytes,
    message: "Cette image dépasse 2 MG !", if: :picture_changed?
  mount_uploader :picture, PictureUploader

  validates_size_of :logo, maximum: 1.megabytes,
    message: "Cette image dépasse 1 MG !", if: :logo_changed?
  mount_uploader :logo, IconUploader

  scope :active, -> { where(active: true) }
  scope :national, -> { where(national: true) }
  scope :around_me, -> (coordinates) { where(national: false).near(coordinates, 99999, order: "distance")}

  validates :name, presence: true
  validates :email, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[\S]+/, message: "Votre URL doit commencer par http:// ou https://" }, allow_blank: true
  validates :civility, inclusion: { in: 1..2 }, allow_blank: true

  # validates :representative_first_name, presence: true
  # validates :representative_last_name, presence: true

  geocoded_by :address

  before_validation :format_city, if: :national_changed?
  after_validation :geocode, if: :address_changed?

  before_save :format_facebook, if: :facebook_changed?
  before_save :format_twitter, if: :twitter_changed?
  before_save :format_instagram, if: :instagram_changed?
  before_save :create_stripe_data!, if: :active_changed?

  after_create :send_registration_slack, :subscribe_to_newsletter_cause
  after_save :update_data_intercom
  after_save :send_activation_slack, if: :active_changed?

  private

  def address_changed?
    street_changed? || zipcode_changed? || city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end

  def format_city
    self.city = "National" if national
  end

  def format_facebook
    self.facebook = self.facebook.split("facebook.com/").last
  end

  def format_twitter
    self.twitter = self.twitter.split("twitter.com/").last
  end

  def format_instagram
    self.instagram = self.instagram.split("instagram.com/").last
  end

  def create_stripe_data!

    return if acct_id.present?
    return unless active

    account = StripeServices.new().create_account(self)

    if account.try(:id)
      self.acct_id = account.id
      account = StripeServices.new().update_account(self)
    end

    if !account.try(:id)
      message = self.name + ": *Stripe : erreur lors de la création ou mise à jour du compte :" + (error.message || "")
      send_message_to_slack(ENV['SLACK_WEBHOOK_CAUSE_URL'], message)
    end
  end

  def subscribe_to_newsletter_cause
    if Rails.env.production?
      SubscribeToNewsletterCause.new(self).run
    end
  end

  def send_registration_slack
    message = self.name
    message += ", *#{city}*," if city.present?
    message += " a rejoint la communauté !"
    send_message_to_slack(ENV['SLACK_WEBHOOK_CAUSE_URL'], message)
  end

  def send_activation_slack
    return unless active
    message = "*#{name}* a été activé !"
    send_message_to_slack(ENV['SLACK_WEBHOOK_CAUSE_URL'], message)
  end

  def update_data_intercom
    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
    begin
      user = intercom.users.create(
        :user_id => 'C'+id.to_s,
        :email => email,
        :name => name,
        :created_at => created_at
      )
      user.custom_attributes["user_type"]   = "cause"
      user.custom_attributes["user_active"] = active
      user.custom_attributes["first_name"]  = representative_first_name
      intercom.users.save(user)
    rescue Intercom::IntercomError => e
      puts e
    end
  end
end
