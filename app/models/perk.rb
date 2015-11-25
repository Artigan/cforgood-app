# == Schema Information
#
# Table name: perks
#
#  id             :integer          not null, primary key
#  perk           :string
#  business_id    :integer
#  description    :text
#  detail         :string
#  periodicity_id :integer
#  times          :integer
#  start_date     :datetime
#  end_date       :datetime
#  permanent      :boolean
#  flash          :boolean
#  active         :boolean
#  perk_code      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_perks_on_business_id     (business_id)
#  index_perks_on_periodicity_id  (periodicity_id)
#

class Perk < ActiveRecord::Base
  belongs_to :business
  belongs_to :periodicity

  scope :permanent, -> { where(permanent: true) }

end

