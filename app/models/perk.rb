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
#  active         :boolean
#  perk_code      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  nb_views       :integer
#
# Indexes
#
#  index_perks_on_business_id     (business_id)
#  index_perks_on_periodicity_id  (periodicity_id)
#

class Perk < ActiveRecord::Base
  belongs_to :business
  belongs_to :periodicity
  has_many :uses, dependent: :destroy

  scope :permanent, -> { where(permanent: true) }
  scope :active, -> { where(active: true) }
  validate :start_date_cannot_be_greater_than_end_date

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "ne doit pas être antérieure à la date de début")
    end
  end

  def update_nb_view!
    self.increment!(:nb_views)
  end
end
