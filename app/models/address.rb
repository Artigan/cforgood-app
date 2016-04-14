# == Schema Information
#
# Table name: addresses
#
#  id          :integer          not null, primary key
#  business_id :integer
#  day         :string
#  street      :string
#  zipcode     :string
#  city        :string
#  latitude    :float
#  longitude   :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean
#  start_time  :time
#  end_time    :time
#
# Indexes
#
#  index_addresses_on_business_id  (business_id)
#
# Foreign Keys
#
#  fk_rails_493c8e25df  (business_id => businesses.id)
#

class Address < ActiveRecord::Base
  belongs_to :business

  scope :active, -> { where(active: true) }

  validates :day, presence: true, :inclusion=> { :in => I18n.t(:"date.day_names") }
  validate :day_uniqueness, if: :day_changed?

  validates :business_id, presence: true
  validates :street, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true


  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  private

  def address_changed?
    :street_changed? || :zipcode_changed? || :city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end

  def day_uniqueness
    if day.present? && business_id.present?
      errors.add(:day, "Ce jour est déjà créé !") if Address.where(day: self.day).where(business_id: self.business_id).count > 0
    end
  end
end
