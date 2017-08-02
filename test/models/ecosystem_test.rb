# == Schema Information
#
# Table name: ecosystems
#
#  id            :integer          not null, primary key
#  name          :string
#  city          :string
#  zipcode       :string
#  radius        :integer
#  latitude      :float
#  longitude     :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  min_longitude :float
#  min_latitude  :float
#  max_longitude :float
#  max_latitude  :float
#

require 'test_helper'

class EcosystemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
