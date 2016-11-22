# == Schema Information
#
# Table name: timetables
#
#  id          :integer          not null, primary key
#  address_id  :integer
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
#  index_timetables_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_2a3c38b2e1  (address_id => addresses.id)
#

class Timetable < ApplicationRecord
end
