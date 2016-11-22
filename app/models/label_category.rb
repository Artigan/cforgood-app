# == Schema Information
#
# Table name: label_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  model      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LabelCategory < ApplicationRecord
  has_many :labels
end
