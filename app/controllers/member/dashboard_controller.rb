  class Member::DashboardController < ApplicationController

  skip_before_action :authenticate_user!, only: [:dashboard]

  def set_impersonation
    if current_user.supervising?(params[:impersonate_id])
      session[:impersonate_id] = params[:impersonate_id]
    else
      session[:impersonate_id] = nil
    end
    redirect_to member_user_dashboard_path(current_user)
  end

  def dashboard
    # save logout access
    if !user_signed_in?
      session[:logout] = true
    end

    # Patch during VIDEO && SALON
    if (current_user.present? && current_user.email == "allan.floury@gmail.com") || !cookies[:coordinates].present?
      lat = 44.837789
      lng = -0.57918
    else
      coordinates = cookies[:coordinates].split('&')
      lat = coordinates[0]
      lng = coordinates[1]
    end

    @businesses_around = Address.joins(:business).merge(Business.active.for_map.with_perks_in_time).near([lat, lng], 10).size
    @businesses = Business.active.for_map.with_perks_in_time.distinct.includes(:business_category, :uses).eager_load(:perks_in_time, :addresses_for_map)
    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      # BUSINESS ADDRESSES
      addresses = []
      # Other addresses
      business.addresses_for_map.each do |address|
        # shop
        addresses << [address.id, address.longitude, address.latitude, address.street] if business.shop and !address.day.present?
        # itinerant
        addresses << [address.id, address.longitude, address.latitude, address.street] if business.itinerant and address.day.present? and address.start_time.strftime('%R') <= Time.now.strftime('%R') and address.end_time.strftime('%R') >= Time.now.strftime('%R')
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
            "color": business.business_category.color,
            "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address[0], street: address[3], flash: false })
          }
        }

        # ONLY BUSINESS WITH FLASH PERK
        business_with_flash = false
        business.perks_in_time.each do |perk|
          business_with_flash = true if perk.flash
        end

        if business_with_flash
          @geojson["features"] << {
            "type": 'Feature',
            "geometry": {
              "type": 'Point',
              "coordinates": [address[1], address[2]]
            },
            "properties": {
              "marker-symbol": business.business_category.marker_symbol+"-flash",
              "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address[0], street: address[3], flash: true })
            }
           }
        end
      end
    end

    @uses_without_feedback = []

    if user_signed_in?
      @uses_without_feedback = current_user.uses.without_feedback
      @beneficiary = Beneficiary.includes(:users).find_by_email(current_user.email)
      @user_offering = @beneficiary.try(:users)
    end

    respond_to do |format|
      format.html
      format.json{render json: @geojson}
    end
  end

  def my_account
    #TODO : Pundit Policy to prevent regular user from accessing this page
    @new_employee = User.new
    @user = User.includes(users: [:used_uses, :liked_uses]).find(params[:user_id])
  end

  def profile
    @cause = Cause.all.includes(:cause_category)
    @payments = Payment.where(user_id: current_user.id).includes(:cause)
  end

  def ambassador
  end

end
