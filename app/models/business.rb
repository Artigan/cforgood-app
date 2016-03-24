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
  has_many :perks, dependent: :destroy

  scope :active, -> { where(active: true) }

  validates :email, presence: true, uniqueness: true
  validates :business_category_id, presence: true
  validates :name, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[\S]+/, message: "Votre URL doit commencer par http:// ou https://" }, allow_blank: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

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

  after_create :send_registration_email, :create_code_promo, :send_registration_slack, :subscribe_to_newsletter_business
  after_save :send_activation_email if :active_changed?

  def perks_uses_count
    perks.reduce(0) { |sum, perk| sum + perk.uses.count }
  end

  def perks_views_count
    perks.reduce(0) { |sum, perk| sum + perk.nb_views.to_i }
  end

  def perks_new_users
    perks.reduce(0) { |sum, perk| sum + perk.uses.select(:user_id).distinct.count }
  end

  private

  def address_changed?
    :street_changed? || :zipcode_changed? || :city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end

  def send_registration_email
    BusinessMailer.registration(self).deliver_now
  end

  def create_code_promo
    partner = Partner.new
    partner.name       = self.name
    partner.email      = self.email
    code = self.name.upcase.gsub(/[^a-zA-Z]/, '').strip
    i = 0
    while Partner.find_by_code_promo(code)
       code += i.to_s
       i += 1
    end
    partner.code_promo = code
    partner.save
  end

  def send_registration_slack
    if !Rails.env.development?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_BUSINESS_URL']
      notifier.ping "#{name}, *#{city}*, a rejoint la communauté !"
    end
  end

  def subscribe_to_newsletter_business
    if !Rails.env.development?
      SubscribeToNewsletterBusiness.new(self).run
    end
  end

  def send_activation_email
    if active_was == false and self.active == true
      BusinessMailer.activation(self).deliver_now
    end
  end
end
