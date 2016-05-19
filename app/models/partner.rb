# == Schema Information
#
# Table name: partners
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  code_promo :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Partner < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :code_partner, presence: true, uniqueness: true

  after_create :update_data_intercom

  private

  def update_data_intercom
    if Rails.env.production?
      # UPDATE CUSTOM ATTRIBUTES ON INTERCOM
      intercom = Intercom::Client.new(app_id: ENV['INTERCOM_API_ID'], api_key: ENV['INTERCOM_API_KEY'])
      begin
        business = intercom.users.find(:email => self.email)
        business.custom_attributes["code_partner"] = self.code_partner
        intercom.users.save(business)
      rescue Intercom::ResourceNotFound
      end
    end
  end
end
