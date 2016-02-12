# == Schema Information
#
# Table name: businesses
#
#  id                          :integer          not null, primary key
#  name                        :string
#  street                      :string
#  zipcode                     :string
#  city                        :string
#  url                         :string
#  telephone                   :string
#  email                       :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  description                 :string
#  picture_file_name           :string
#  picture_content_type        :string
#  picture_file_size           :integer
#  picture_updated_at          :datetime
#  business_category_id        :integer
#  latitude                    :float
#  longitude                   :float
#  facebook                    :string
#  twitter                     :string
#  instagram                   :string
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  leader_picture_file_name    :string
#  leader_picture_content_type :string
#  leader_picture_file_size    :integer
#  leader_picture_updated_at   :datetime
#  leader_first_name           :string
#  leader_last_name            :string
#  leader_description          :string
#  active                      :boolean          default(FALSE), not null
#  online                      :boolean          default(FALSE), not null
#  leader_phone                :string
#  leader_email                :string
#  logo_file_name              :string
#  logo_content_type           :string
#  logo_file_size              :integer
#  logo_updated_at             :datetime
#
# Indexes
#
#  index_businesses_on_business_category_id  (business_category_id)
#  index_businesses_on_email                 (email) UNIQUE
#  index_businesses_on_reset_password_token  (reset_password_token) UNIQUE
#

class BusinessesController < ApplicationController

  before_action :authenticate_user!

  def index
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct

    # Let's DYNAMICALLY build the markers for the view.
    @markers = Gmaps4rails.build_markers(@businesses) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).marker.url(:marker),
        width: 40,
        height: 43
      })
      marker.infowindow render_to_string(partial: "components/map_box", locals: { business: business })
    end
  end

  def show
    @business = Business.find(params[:id])
    @markers = Gmaps4rails.build_markers(@business) do |business, marker|
      marker.lat business.latitude
      marker.lng business.longitude
      marker.picture({
        url: BusinessCategory.find(business.business_category_id).marker.url(:marker),
        width: 40,
        height: 43
      })
    end
  end
end
