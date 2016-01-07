# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  uid                    :string
#  name                   :string
#  token                  :string
#  token_expiry           :datetime
#  admin                  :boolean          default(FALSE), not null
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  birthday               :datetime
#  nationality            :string
#  country_of_residence   :string
#  mangopay_id            :string
#  card_id                :string
#  cause_id               :integer
#  member                 :boolean          default(FALSE), not null
#  subscription           :string
#  trial_done             :boolean          default(FALSE), not null
#  date_subscription      :datetime
#  date_last_payment      :datetime
#  active                 :boolean          default(FALSE), not null
#  street                 :string
#  zipcode                :string
#  city                   :string
#  latitude               :float
#  longitude              :float
#
# Indexes
#
#  index_users_on_cause_id              (cause_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  # has_one :cause
  has_many :uses, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  after_save :trial_done!, if: :subscription_changed?
  validate :date_subscription!, if: :subscription_changed?
  validate :member!, if: :date_last_payment_changed?

  def self.find_for_google_oauth2(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
    registred_user = User.where(:email => access_token.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: data['name'],
          provider: access_token.provider,
          email: data['email'],
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
    registred_user = User.where(:email => data.email).first
      if registred_user
        return registred_user
      else
        user = User.create(
          name: access_token.extra.raw_info.name,
          provider: access_token.provider,
          email: data.email,
          uid: access_token.uid,
          picture: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  def should_payin?
    self.subscription != nil && self.subscription[0] != "T" &&
    (self.date_last_payment == nil || self.date_last_payment < Time.now.prev_month)
  end

  def date_subscription!
    self.date_subscription = Time.now if subscription_was == nil
  end

  def member!
    self.member = true
  end

  def trial_done?
    self.subscription[0] == "T" || self.trial_done == true
  end

  def trial_done!
    if subscription_was != nil && subscription_was[0] == "T" && self.trial_done == false
      self.update(trial_done: true)
    end
  end
end
