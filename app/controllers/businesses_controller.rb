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
    @businesses = Business.joins(:perks).where("perks.active = ?", true).distinct
  end

  def show
    @business = Business.find(params[:id])

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @geojson["features"] << {
      "type": 'Feature',
      "geometry": {
        "type": 'Point',
        "coordinates": [@business.longitude, @business.latitude],
      },
      "properties": {
        "marker-symbol": @business.business_category.marker_symbol
      }
    }
    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
