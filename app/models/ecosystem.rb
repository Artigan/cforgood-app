# == Schema Information
#
# Table name: ecosystems
#
#  id            :integer          not null, primary key
#  name          :string
#  city          :string
#  zipcode       :string
#  radius        :integer
#  latitude      :float
#  longitude     :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  min_longitude :float
#  min_latitude  :float
#  max_longitude :float
#  max_latitude  :float
#

class Ecosystem < ApplicationRecord

  validates :zipcode, presence: true
  validates :city, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  after_validation :set_bounding_box, if: :address_changed?

  scope :within, -> (coordinates) { where("min_latitude <= ? AND max_latitude >= ? AND min_longitude <= ? AND max_longitude >= ?", coordinates[0], coordinates[0], coordinates[1], coordinates[1]) }

  private

  def address_changed?
    zipcode_changed? || city_changed?
  end

  def address
    "#{zipcode} #{city}"
  end

  def set_bounding_box
    box = Geocoder::Calculations.bounding_box([latitude, longitude], radius)
    self.min_latitude  = box[0]
    self.min_longitude = box[1]
    self.max_latitude  = box[2]
    self.max_longitude = box[3]
  end
end
