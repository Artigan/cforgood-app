# == Schema Information
#
# Table name: periodicities
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Periodicity < ActiveRecord::Base
  has_many :perks
end
