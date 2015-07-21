# == Schema Information
#
# Table name: businesses
#
#  id          :integer          not null, primary key
#  name        :string
#  category    :string
#  street      :string
#  zipcode     :string
#  city        :string
#  url         :string
#  telephone   :string
#  email       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#  perk        :string
#

class Business < ActiveRecord::Base
end
