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
#  all_day              :boolean          default(FALSE), not null
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
  scope :in_time, -> { where('perks.active = ? and (perks.durable = ? or perks.appel = ? or (perks.flash = ? and perks.start_date <= ? and perks.end_date >= ?))', true, true, true, true, Time.now, Time.now) }
  scope :flash_in_time, -> { where('perks.active = ? and perks.flash = ? and perks.start_date <= ? and perks.end_date >= ?', true, true, Time.now, Time.now) }

  extend TimeSplitter::Accessors
  split_accessor :start_date, :end_date

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
  after_create :update_data_intercom
  after_save :update_data_intercom if :active_changed?
  after_destroy :update_data_intercom

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
      (self.start_date <= Time.now && self.end_date >= Time.now) && (self.times == 0 || Use.where(perk_id: self.id).count < self.times)
    else
      true
    end
  end

  def deleted!
    self.update(active: false, deleted: true)
  end

  private

  def dates_required_if_flash
    if flash
      if !start_date.present?
        errors.add(:start_date, "La date de début est obligatoire pour un bon plan flash.")
      end
      if !end_date.present? && !all_day
        errors.add(:end_date, "La date de fin est obligatoire pour un bon plan flash.")
      end
      if all_day && start_date.present?
        self.start_date = start_date.change(hour: 0, min: 0)
        self.end_date = start_date.change(hour: 23, min: 59)
      else
        self.end_date = end_date.change(min: 0)
      end
    end
  end

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "La date de fin ne doit pas être antérieure à la date de début.")
    end
  end

  def send_registration_slack
    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_PERK_URL']
      notifier.ping "#{self.business.name} a créé un nouveau bon plan : #{name}"
    end
  end

  def name_uniqueness
    if name.present?
      name.upcase!
      errors.add(:name, "Ce nom de bon plan est déjà utilisé !") if Perk.where(name: self.name, deleted: false).where(business_id: self.business_id).count > 0
    end
  end

  def perk_code_uniqueness
    if perk_code.present?
      perk_code.upcase!
      errors.add(:perk_code, "Ce code n'est pas disponible !") if Perk.where(perk_code: self.perk_code, deleted: false).where(business_id: self.business_id).count > 0
    end
  end

  def update_data_intercom
    if Rails.env.production?
      # UPDATE CUSTOM ATTRIBUTES ON INTERCOM
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        user = intercom.users.find(:user_id => 'B'+self.business_id.to_s)
        user.custom_attributes[:perks_all] = Business.find(self.business_id).perks.count
        user.custom_attributes[:perks_active] = Business.find(self.business_id).perks.active.count
        intercom.users.save(user)
      rescue Intercom::ResourceNotFound
      end
    end
  end

  def active?
    if flash
      end_date < DateTime.now
    else
      active
    end
  end
end
