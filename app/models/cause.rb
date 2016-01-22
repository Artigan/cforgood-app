# == Schema Information
#
# Table name: causes
#
#  id                        :integer          not null, primary key
#  name                      :string
#  description               :string
#  street                    :string
#  zipcode                   :string
#  city                      :string
#  url                       :string
#  email                     :string
#  telephone                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  impact                    :string
#  picture_file_name         :string
#  picture_content_type      :string
#  picture_file_size         :integer
#  picture_updated_at        :datetime
#  cause_category_id         :integer
#  facebook                  :string
#  twitter                   :string
#  instagram                 :string
#  description_impact        :string
#  latitude                  :float
#  longitude                 :float
#  mangopay_id               :string
#  wallet_id                 :string
#  representative_first_name :string
#  representative_last_name  :string
#  logo_file_name            :string
#  logo_content_type         :string
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#
# Indexes
#
#  index_causes_on_cause_category_id  (cause_category_id)
#

class Cause < ActiveRecord::Base
  belongs_to   :cause_category
  belongs_to   :user

  has_attached_file :picture,
    styles: { medium: "300x300>", small: "200x200", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  has_attached_file :logo,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :logo,
    content_type: /\Aimage\/.*\z/

  validates :name, presence: true
  validates :email, presence: true
  # validates :representative_first_name, presence: true
  # validates :representative_last_name, presence: true
end

