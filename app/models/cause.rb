# == Schema Information
#
# Table name: causes
#
#  id                        :integer          not null, primary key
#  name                      :string
#  description               :text
#  street                    :string
#  zipcode                   :string
#  city                      :string
#  url                       :string
#  email                     :string
#  telephone                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  impact                    :string
#  picture_file_name         :string
#  picture_content_type      :string
#  picture_file_size         :integer
#  picture_updated_at        :datetime
#  cause_category_id         :integer
#  facebook                  :string
#  twitter                   :string
#  instagram                 :string
#  description_impact        :string
#  latitude                  :float
#  longitude                 :float
#  mangopay_id               :string
#  wallet_id                 :string
#  representative_first_name :string
#  representative_last_name  :string
#  logo_file_name            :string
#  logo_content_type         :string
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#  amount_impact             :integer
#  active                    :boolean          default(FALSE), not null
#
# Indexes
#
#  index_causes_on_cause_category_id  (cause_category_id)
#

class Cause < ActiveRecord::Base
  belongs_to :cause_category
  has_many :users

  has_attached_file :picture,
    styles: { medium: "300x300>", small: "200x200", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  has_attached_file :logo,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :logo,
    content_type: /\Aimage\/.*\z/

  validates :name, presence: true
  validates :email, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[\S]+/, message: "Votre URL doit commencer par http:// ou https://" }, allow_blank: true

  # validates :representative_first_name, presence: true
  # validates :representative_last_name, presence: true

  after_create :subscribe_to_newsletter_cause
  after_save :update_data_intercom

  private

  def subscribe_to_newsletter_cause
    # if Rails.env.production?
      SubscribeToNewsletterCause.new(self).run
    # end
  end

  def update_data_intercom
    if Rails.env.production?
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        user = intercom.users.create(
          :user_id => 'C'+id.to_s,
          :email => email,
          :name => name,
          :created_at => created_at
        )
        user.custom_attributes["user_type"]   = "cause"
        user.custom_attributes["user_active"] = active
        user.custom_attributes["first_name"]  = representative_first_name
        intercom.users.save(user)
      rescue Intercom::ResourceNotFound
      end
    end
  end
end

