# == Schema Information
#
# Table name: partners
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  code_promo :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Partner < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :code_promo, presence: true, uniqueness: true

  has_many :users
end
