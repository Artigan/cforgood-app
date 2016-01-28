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
#  times          :integer          default(0)
#  start_date     :datetime
#  end_date       :datetime
#  permanent      :boolean          default(TRUE), not null
#  active         :boolean          default(TRUE), not null
#  perk_code      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  nb_views       :integer          default(0)
#  appel          :boolean          default(FALSE), not null
#  durable        :boolean          default(FALSE), not null
#  flash          :boolean          default(FALSE), not null
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

  validate :dates_required_if_flash
  validate :start_date_cannot_be_greater_than_end_date
  validate :generate_code

  def dates_required_if_flash
    if !permanent && !start_date.present?
      errors.add(:start_date, "La date de début est obligatoire pour un bon plan flash.")
    end
    if !permanent && !end_date.present?
      errors.add(:end_date, "La date de fin est obligatoire pour un bon plan flash.")
    end
  end

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "La date de fin ne doit pas être antérieure à la date de début.")
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
    if self.durable
      true
    elsif self.appel
      user.uses.where(perk_id: self.id).count == 0
    elsif self.flash
      raise
      Time.now >= self.start_date && Time.now <= self.end_date && (self.times == 0 || Use.where(perk_id: self.id).count < self.times)
    end
  end
end
