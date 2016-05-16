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
#  description                 :text
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
#  leader_description          :text
#  active                      :boolean          default(FALSE), not null
#  online                      :boolean          default(FALSE), not null
#  leader_phone                :string
#  leader_email                :string
#  logo_file_name              :string
#  logo_content_type           :string
#  logo_file_size              :integer
#  logo_updated_at             :datetime
#  shop                        :boolean          default(TRUE), not null
#  itinerant                   :boolean          default(FALSE), not null
#
# Indexes
#
#  index_businesses_on_business_category_id  (business_category_id)
#  index_businesses_on_email                 (email) UNIQUE
#  index_businesses_on_reset_password_token  (reset_password_token) UNIQUE
#

class BusinessesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @businesses = Business.active.joins(:perks).active.distinct
    @addresses_id = []
    @businesses.each do |business|
      @addresses_id << [business.id, 0] # BUSINESS MAIN ADDRESS
      business.addresses.shop.each do |address_shop|
        @addresses_id << [business.id, address_shop.id]
      end
      if business.itinerant
        business.addresses.active.today.each do |address_itinerant|
           @addresses_id << [business.id, address_itinerant.id]
        end
      end
    end
    @addresses_id.delete([]) # REMOVE WHEN NO ACTIVE RECORD ASSOCIATION
  end

  def show
    @business = Business.find(params[:id])
    @perk = @business.perks.find(params[:perk_id])

    if params[:address_id].to_i > 0
      @address = @business.addresses.find(params[:address_id])
      longitude = @address.longitude
      latitude = @address.latitude
    else
      longitude = @business.longitude
      latitude = @business.latitude
    end

    @geojson = {"type" => "FeatureCollection", "features" => []}

    @geojson["features"] << {
      "type": 'Feature',
      "geometry": {
        "type": 'Point',
        "coordinates": [longitude, latitude],
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
