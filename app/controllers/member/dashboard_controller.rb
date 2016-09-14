class Member::DashboardController < ApplicationController

  skip_before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    byebug
    # Patch during VIDEO && SALON
    if (current_user.present? && current_user.email == "allan.floury@gmail.com") || !cookies[:coordinates].present?
      lat = 44.837789
      lng = -0.57918
    else
      coordinates = cookies[:coordinates].split('&')
      lat = coordinates[0]
      lng = coordinates[1]
    end
    @businesses_around = Business.near([lat, lng], 10).active.for_map.joins(:perks).merge(Perk.in_time).distinct.size
    @businesses = Business.active.for_map.joins(:perks).merge(Perk.in_time).distinct.includes(:business_category)
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

    @uses_without_feedback = []
    if current_user.present?
      @uses_without_feedback = current_user.uses.without_feedback
    end

    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end

  def profile
    @cause = Cause.all.includes(:cause_category)
    @payments = Payment.where(user_id: current_user.id).includes(:cause)
  end


end
