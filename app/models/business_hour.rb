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

class BusinessHour < ApplicationRecord
  belongs_to :business

  extend TimeSplitter::Accessors
  split_accessor :am_start_at, :am_end_at, :pm_start_at, :pm_end_at

  def open?(time)
    # false if time is "inside" any of the closed_time_blocks
    # else is true if inside any of the open_time_blocks
    # else is false
  end

  def closed?(time)
    !open?
  end

end
