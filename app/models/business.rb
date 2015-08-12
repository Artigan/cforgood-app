# == Schema Information
#
# Table name: businesses
#
#  id                   :integer          not null, primary key
#  name                 :string
#  street               :string
#  zipcode              :string
#  city                 :string
#  url                  :string
#  telephone            :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :string
#  perk                 :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  business_category_id :integer
#  detail               :string
#
# Indexes
#
#  index_businesses_on_business_category_id  (business_category_id)
#

class Business < ActiveRecord::Base
  belongs_to   :business_category

  has_attached_file :picture,
      styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
      content_type: /\Aimage\/.*\z/
end
