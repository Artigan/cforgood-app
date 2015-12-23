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
#  permanent      :boolean          default(TRUE), not null
#  active         :boolean          default(FALSE), not null
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

  validates :times, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  validate :start_date_cannot_be_greater_than_end_date
  validate :generate_code

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "ne doit pas être antérieure à la date de début")
    end
  end

  def generate_code
    until perk_code
      code = ("A".."Z").to_a.sample(4).join
      code += (0..9).to_a.sample.to_s
      self.perk_code = code if !Perk.find_by_perk_code(code)
    end
  end

  def update_nb_view!
    self.increment!(:nb_views)
  end

  def perk_usable?(user)
    if self.permanent
      if self.times
        if self.periodicity_id
          date = Time.now
          case Periodicity.find(self.periodicity_id)
            when "Semaine"
              date = date.prev_week
            when "Mois"
              date = date.prev_month
            when "Année"
              date = date.prev_year
          end
          user.uses.where("perk_id = :id and created_at >= :date", {id: self.id, date: date} ).count >= self.times
        else
          user.uses.where(perk_id: self.id).count >= self.times
        end
      end
    else
      Time.now < self.start_date || Time.now > self.end_date
    end
  end
end
