# == Schema Information
#
# Table name: perks
#
#  id                   :integer          not null, primary key
#  name                 :string
#  business_id          :integer
#  description          :text
#  times                :integer          default(0)
#  start_date           :datetime
#  end_date             :datetime
#  active               :boolean          default(TRUE), not null
#  perk_code            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  nb_views             :integer          default(0)
#  appel                :boolean          default(FALSE), not null
#  durable              :boolean          default(FALSE), not null
#  flash                :boolean          default(FALSE), not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  perk_detail_id       :integer
#  deleted              :boolean          default(FALSE), not null
#
# Indexes
#
#  index_perks_on_business_id     (business_id)
#  index_perks_on_perk_detail_id  (perk_detail_id)
#
# Foreign Keys
#
#  fk_rails_5797f2b98a  (business_id => businesses.id)
#

class Perk < ActiveRecord::Base
  belongs_to :business
  has_many :uses, dependent: :destroy
  belongs_to :perk_detail

  scope :active, -> { where(active: true) }
  scope :undeleted, -> { where(deleted: false) }

  validates :name, presence: true, length: { maximum: 35 }
  validate :name_uniqueness, if: :name_changed?
  validates :description, presence: true, length: { maximum: 220 }
  validates :perk_detail_id, presence: true
  validates :times, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate :dates_required_if_flash
  validate :start_date_cannot_be_greater_than_end_date
  validates :perk_code, length: { in: 5..15 }, format: { with: /\A[A-Za-z0-9]+\z/, message: "Le code du bon plan ne peut contenir que des lettres et des chiffres" }
  validate :perk_code_uniqueness, if: :perk_code_changed?

  has_attached_file :picture,
    styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  after_create :send_registration_slack

  def update_nb_view!
    self.increment!(:nb_views)
  end

  def perk_usable?(user)
    if self.durable
      true
    elsif self.appel
      user.uses.where(perk_id: self.id).count == 0
    elsif self.flash
      self.times == 0 || Use.where(perk_id: self.id).count < self.times
    end
  end

  def perk_in_time?
    if self.flash
      Time.now >= self.start_date && Time.now <= self.end_date
    else
      true
    end
  end

  def deleted!
    self.update(active: false, deleted: true)
  end

  private

  def dates_required_if_flash
    if flash && !start_date.present?
      errors.add(:start_date, "La date de début est obligatoire pour un bon plan flash.")
    end
    if flash && !end_date.present?
      errors.add(:end_date, "La date de fin est obligatoire pour un bon plan flash.")
    end
  end

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "La date de fin ne doit pas être antérieure à la date de début.")
    end
  end

  def send_registration_slack
    if !Rails.env.development?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_PERK_URL']
      notifier.ping "#{self.business.name} a créé un nouveau bon plan : #{name}"
    end
  end

  def name_uniqueness
    if name.present?
      name.upcase!
      errors.add(:name, "Ce nom de bon plan est déjà utilisé !") if Perk.where(name: self.name).where(business_id: self.business_id).count > 0
    end
  end

  def perk_code_uniqueness
    if perk_code.present?
      perk_code.upcase!
      errors.add(:perk_code, "Ce code n'est pas disponible !") if Perk.where(perk_code: self.perk_code).where(business_id: self.business_id).count > 0
    end
  end
end
