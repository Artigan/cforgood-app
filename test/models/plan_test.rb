# == Schema Information
#
# Table name: plans
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  subscription     :string
#  amount           :integer
#  code_partner     :string
#  date_end_partner :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_plans_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_45da853770  (user_id => users.id)
#

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
