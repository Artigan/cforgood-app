# == Schema Information
#
# Table name: beneficiaries
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  first_name   :string
#  last_name    :string
#  email        :string
#  used         :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code_partner :string
#  paid         :boolean          default(FALSE), not null
#
# Indexes
#
#  index_beneficiaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_2d8fc173f1  (user_id => users.id)
#

class Beneficiary < ApplicationRecord
  belongs_to :users

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
