# == Schema Information
#
# Table name: business_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BusinessCategory < ActiveRecord::Base
  has_many :businesses
end
