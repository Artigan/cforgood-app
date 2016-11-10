# == Schema Information
#
# Table name: business_hours
#
#  id          :integer          not null, primary key
#  business_id :integer
#  day         :string
#  am_start_at :datetime
#  am_end_at   :datetime
#  pm_start_at :datetime
#  pm_end_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_business_hours_on_business_id  (business_id)
#
# Foreign Keys
#
#  fk_rails_48682d449c  (business_id => businesses.id)
#

require 'test_helper'

class BusinessHourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
