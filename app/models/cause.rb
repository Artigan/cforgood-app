# == Schema Information
#
# Table name: causes
#
#  id          :integer          not null, primary key
#  name        :string
#  type        :string
#  description :string
#  street      :string
#  zipcode     :string
#  city        :string
#  url         :string
#  email       :string
#  telephone   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cause < ActiveRecord::Base
end
