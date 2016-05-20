class Member::DashboardController < ApplicationController

  skip_before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    binding.pry
    @businesses = Business.active.for_map.joins(:perks).merge(Perk.in_time).distinct
    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      # BUSINESS ADDRESSES : MAIN AND OTHER SHOP
      addresses = []
      if business.shop
        addresses << [0, business.longitude, business.latitude, business.street]
        business.addresses.shop.each do |address|
          addresses << [address.id, address.longitude, address.latitude]
        end
      end
      # BUSINESS : ITINERANT SHOP
      if business.itinerant && business.addresses.active.today.count > 0
        if business.addresses.active.today.in_time
          addresses << [business.addresses.active.today.first.id, business.addresses.active.today.first.longitude, business.addresses.active.today.first.latitude]
        end
      end
      # LOAD ADDRESSES
      addresses.uniq!
      addresses.each do |address|
        @geojson["features"] << {
          "type": 'Feature',
          "geometry": {
            "type": 'Point',
            "coordinates": [address[1], address[2]]
          },
          "properties": {
            "marker-symbol": business.business_category.marker_symbol,
           "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address[0], flash: false })
          }
        }
        # ONLY BUSINESS WITH FLASH PERK
        if business.perks.flash_in_time.count > 0
          @geojson["features"] << {
            "type": 'Feature',
            "geometry": {
              "type": 'Point',
              "coordinates": [address[1], address[2]]
            },
            "properties": {
              "marker-symbol": business.business_category.marker_symbol+"-flash",
              "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address[0], flash: true })
            }
           }
        end
      end
    end

    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end
end
