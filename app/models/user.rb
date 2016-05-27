# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  uid                    :string
#  name                   :string
#  token                  :string
#  token_expiry           :datetime
#  admin                  :boolean          default(FALSE), not null
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  birthday               :datetime
#  nationality            :string
#  country_of_residence   :string
#  mangopay_id            :string
#  card_id                :string
#  cause_id               :integer
#  member                 :boolean          default(FALSE), not null
#  subscription           :string
#  trial_done             :boolean          default(FALSE), not null
#  date_subscription      :datetime
#  date_last_payment      :datetime
#  active                 :boolean          default(TRUE), not null
#  street                 :string
#  zipcode                :string
#  city                   :string
#  latitude               :float
#  longitude              :float
#  date_partner           :date
#  code_partner           :string
#  date_support           :date
#  amount                 :integer
#
# Indexes
#
#  index_users_on_cause_id              (cause_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_130d5504e9  (cause_id => causes.id)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  belongs_to :cause
  has_many :uses
  has_many :payments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :city, presence: true

  has_attached_file :picture,
    styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validate :code_partner?, if: :code_partner_changed?

  before_create :default_cause_id!

  after_validation :trial_done!, if: :subscription_changed?
  after_validation :subscription!, if: :subscription_changed?

  after_create :send_registration_slack, :subscribe_to_newsletter_user

  before_save :date_support!, if: :cause_id_changed?

  after_save :update_data_intercom

  def self.find_for_google_oauth2(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
      registred_user = User.where(:email => access_token.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: data['name'],
          first_name: data['first_name'],
          last_name: data['last_name'],
          provider: access_token.provider,
          email: data['email'],
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first
    if user
      return user
    else
      registred_user = User.where(:email => data.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: access_token.extra.raw_info.name,
          first_name: access_token.extra.raw_info.first_name,
          last_name: access_token.extra.raw_info.last_name,
          city: access_token.extra.raw_info.location.name.split(",").first,
          provider: access_token.provider,
          email: data.email,
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  def should_payin?
    @partner = Partner.find_by_code_partner(self.code_partner)
    nb_month = 1
    nb_month = @partner.month  if @parner.present?
    self.subscription != nil && self.subscription != "T" &&
    (self.date_last_payment == nil || self.date_last_payment < Time.now - nb_month.month)
  end

  def find_name?
    if self.first_name.present?
      name = self.first_name
    elsif self.name.present?
      name = self.name
    else
      name = ""
    end
  end

  def member!
    self.member = true
  end

  private

  def subscription!
    # IF NOT EXIST, CREATE NEW USER NATURAL FOR MANGOPAY
    if !self.mangopay_id.present?
      @mangopay_user = MangopayServices.new(self).create_mangopay_natural_user
      self.mangopay_id = @mangopay_user["Id"]
    end
    # UPDATE DATE SUBCRIPTION
    self.date_subscription = Time.now if subscription_was == nil
  end

  def date_support!
    self.date_support = Time.now
  end

  def trial_done?
    self.subscription.present? && (self.subscription[0] == "T" || self.trial_done == true)
  end

  def trial_done!
    if subscription_was.present? && subscription_was[0] == "T" && self.trial_done == false
      self.update(trial_done: true)
    end
  end

  def code_partner?
    if code_partner.present?
      if Partner.find_by_code_partner(code_partner.upcase)
        self.code_partner.upcase!
        self.date_partner = Time.now
      else
        errors.add(:code_partner, "Code promotionnel invalide")
      end
    end
  end

  def address_changed?
    street_changed? || zipcode_changed? || city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end

  def default_cause_id!
    if !self.cause_id.present?
      self.cause_id = ENV['CAUSE_ID_CFORGOOD']
    end
  end

  def send_registration_slack
    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_USER_URL']

      if last_name.present?
        message = "#{first_name} #{last_name}"
      elsif name.present?
        message = "#{name}"
      else
        massage = "#{email}"
      end

      if city.present?
        message = message + ", *#{city}*,"
      end

      message = message + " a rejoint la communauté !"

      notifier.ping message

    end
  end

  def subscribe_to_newsletter_user
    if Rails.env.production?
      SubscribeToNewsletterUser.new(self).run
    end
  end

  def create_data_amplitude
    # Configure your Amplitude API key
    AmplitudeAPI.api_key = ENV["AMPLITUDE_API_KEY"]

    event = AmplitudeAPI::Event.new({
      user_id: self.id,
      event_type: "SIGNUP_USER",
      user_properties: {
        user_type: "user",
        city: self.city
      }
    })
    AmplitudeAPI.track(event)
  end

  def update_data_intercom
    # UPDATE CUSTOM ATTRIBUTES ON INTERCOM
    if active_changed? or cause_id_changed? or member_changed?
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        user = intercom.users.find(:user_id => self.id)
        user.custom_attributes["user_active"] = self.active
        user.custom_attributes["user_cause"] = self.cause.name
        user.custom_attributes["user_member"] = self.member
        intercom.users.save(user)
      rescue Intercom::ResourceNotFound
      end
    end
  end
end
