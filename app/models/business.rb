# == Schema Information
#
# Table name: businesses
#
#  id                        :integer          not null, primary key
#  name                      :string
#  street                    :string
#  zipcode                   :string
#  city                      :string
#  url                       :string
#  telephone                 :string
#  email                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :string
#  picture_file_name         :string
#  picture_content_type      :string
#  picture_file_size         :integer
#  picture_updated_at        :datetime
#  business_category_id      :integer
#  latitude                  :float
#  longitude                 :float
#  facebook                  :string
#  twitter                   :string
#  instagram                 :string
#  user_picture_file_name    :string
#  user_picture_content_type :string
#  user_picture_file_size    :integer
#  user_picture_updated_at   :datetime
#
# Indexes
#
#  index_businesses_on_business_category_id  (business_category_id)
#

class Business < ActiveRecord::Base
  belongs_to  :business_category
  has_many :perks

  validates :email, presence: true, uniqueness: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attached_file :picture,
      styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
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
end
