# == Schema Information
#
# Table name: business_categories
#
#  id                   :integer          not null, primary key
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  marker_file_name     :string
#  marker_content_type  :string
#  marker_file_size     :integer
#  marker_updated_at    :datetime
#  color                :string
#

class BusinessCategory < ActiveRecord::Base
  has_many :businesses

  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  has_attached_file :marker,
    styles: { marker: "40X43>" }

  validates_attachment_content_type :marker,
    content_type: /\Aimage\/.*\z/
end
