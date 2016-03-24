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
#  active      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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

  validates :day, :inclusion=> { :in => I18n.t(:"date.day_names") }

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  private

  def address_changed?
    :street_changed? || :zipcode_changed? || :city_changed?
  end

  def address
    "#{street}, #{zipcode} #{city}"
  end
end
