# == Schema Information
#
# Table name: causes
#
#  id                   :integer          not null, primary key
#  name                 :string
#  type                 :string
#  description          :string
#  street               :string
#  zipcode              :string
#  city                 :string
#  url                  :string
#  email                :string
#  telephone            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  impact               :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Cause < ActiveRecord::Base
  has_attached_file :picture,
      styles: { medium: "300x300>", thumb: "100x100>" }

    validates_attachment_content_type :picture,
      content_type: /\Aimage\/.*\z/
end
