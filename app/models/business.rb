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
#  description                 :string
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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to  :business_category
  has_many :perks

  validates :email, presence: true, uniqueness: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attached_file :picture,
      styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
      content_type: /\Aimage\/.*\z/

  has_attached_file :leader_picture,
      styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :leader_picture,
      content_type: /\Aimage\/.*\z/

  def address_changed?
    :street_changed? || :zipcode_changed? || :city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end

  def gmaps4rails_infowindow
    "#{link_to 'Business', business_path}"
  end

  def activated
    self.joins(:perks).where("perks.permanent = ?", true)
  end

  def perks_uses_count
    perks.reduce(0) { |sum, perk| sum + perk.uses.count }
  end
end
