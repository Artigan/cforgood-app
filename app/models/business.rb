# == Schema Information
#
# Table name: businesses
#
#  id                          :integer          not null, primary key
#  name                        :string
#  street                      :string
#  zipcode                     :string
#  city                        :string
#  url                         :string
#  telephone                   :string
#  email                       :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  description                 :text
#  picture_file_name           :string
#  picture_content_type        :string
#  picture_file_size           :integer
#  picture_updated_at          :datetime
#  business_category_id        :integer
#  latitude                    :float
#  longitude                   :float
#  facebook                    :string
#  twitter                     :string
#  instagram                   :string
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  leader_picture_file_name    :string
#  leader_picture_content_type :string
#  leader_picture_file_size    :integer
#  leader_picture_updated_at   :datetime
#  leader_first_name           :string
#  leader_last_name            :string
#  leader_description          :text
#  active                      :boolean          default(FALSE), not null
#  online                      :boolean          default(FALSE), not null
#  leader_phone                :string
#  leader_email                :string
#  logo_file_name              :string
#  logo_content_type           :string
#  logo_file_size              :integer
#  logo_updated_at             :datetime
#  shop                        :boolean          default(TRUE), not null
#  itinerant                   :boolean          default(FALSE), not null
#
# Indexes
#
#  index_businesses_on_business_category_id  (business_category_id)
#  index_businesses_on_email                 (email) UNIQUE
#  index_businesses_on_reset_password_token  (reset_password_token) UNIQUE
#

class Business < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  belongs_to :business_category
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank
  has_many :perks, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :for_map, -> { where('businesses.shop = ? or businesses.itinerant = ?', true, true) }


  validates :email, presence: true, uniqueness: true
  validates :business_category_id, presence: true
  validates :name, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[\S]+/, message: "Votre URL doit commencer par http:// ou https://" }, allow_blank: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  before_save :controle_geocode!, if: :address_changed?

  has_attached_file :picture,
      styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :picture,
      content_type: /\Aimage\/.*\z/

  has_attached_file :leader_picture,
      styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :leader_picture,
      content_type: /\Aimage\/.*\z/

  has_attached_file :logo,
      styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :logo,
      content_type: /\Aimage\/.*\z/

  after_create :create_code_partner, :send_registration_slack, :subscribe_to_newsletter_business

  after_save :update_data_intercom

  def perks_uses_count
    perks.reduce(0) { |sum, perk| sum + perk.uses.count }
  end

  def perks_views_count
    perks.reduce(0) { |sum, perk| sum + perk.nb_views.to_i }
  end

  def perks_new_users
    perks.reduce(0) { |sum, perk| sum + perk.uses.select(:user_id).distinct.count }
  end

  def address_changed?
    street_changed? || zipcode_changed? || city_changed?
  end

  private

  def address
    "#{street}, #{zipcode} #{city}"
  end

  # def send_registration_email
  #   BusinessMailer.registration(self).deliver_now
  # end

  def create_code_partner
    Partner.new.create_code_partner(self.name, self.email)
  end

  def send_registration_slack
    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_BUSINESS_URL']
      notifier.ping "#{name}, *#{city}*, a rejoint la communauté !"
    end
  end

  def subscribe_to_newsletter_business
    if Rails.env.production?
      SubscribeToNewsletterBusiness.new(self).run
    end
  end

  def update_data_intercom
    if active_changed? or leader_first_name_changed?
      # UPDATE CUSTOM ATTRIBUTES ON INTERCOM
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        user = intercom.users.find(:user_id => 'B'+id.to_s)
        user.custom_attributes["user_active"] = self.active
        user.custom_attributes["first_name"] =  self.leader_first_name
        intercom.users.save(user)
      rescue Intercom::ResourceNotFound
      end
    end
  end

  def controle_geocode!
    while Business.where('id != ? and latitude = ? and longitude = ?', self.id, latitude, longitude).count > 0
      self.latitude -= 0.0001
      self.longitude += 0.0001
    end
  end

end
