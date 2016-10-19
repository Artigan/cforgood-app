# == Schema Information
#
# Table name: prospects
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  street      :string
#  zipcode     :string
#  city        :string
#  leader_name :string
#  email       :string
#  canvassed   :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_prospects_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_4208a7b971  (user_id => users.id)
#

class Prospect < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :street, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true

end
