# == Schema Information
#
# Table name: business_categories
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  marker_symbol :string
#  picture       :string
#

class BusinessCategory < ActiveRecord::Base
  has_many :businesses

  validates_size_of :picture, maximum: 1.megabytes,
    message: "Cette image dépasse 1 MG !", if: :picture_changed?
  mount_uploader :picture, PictureUploader

  has_attached_file :s3_picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :s3_picture,
    content_type: /\Aimage\/.*\z/
end
