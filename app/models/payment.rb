# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cause_id   :integer
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_payments_on_cause_id  (cause_id)
#  index_payments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_081dc04a02  (user_id => users.id)
#  fk_rails_de053cb0c6  (cause_id => causes.id)
#

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :cause

  validates :user_id, presence: true
  validates :cause_id, presence: true
  validates :amount, presence: true
end
