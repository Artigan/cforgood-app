# == Schema Information
#
# Table name: partners
#
#  id           :integer          not null, primary key
#  name         :string
#  email        :string
#  code_partner :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Partner < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :code_partner, presence: true, uniqueness: true
end
