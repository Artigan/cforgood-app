  class Member::DashboardController < ApplicationController

  skip_before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    # save logout access
    if !user_signed_in?
      session[:logout] = true
    end

    # Patch during VIDEO && SALON
    if params[:lng].present? && params[:lat].present?
      lat = params[:lat]
      lng = params[:lng]
    elsif (current_user.present? && current_user.email == "allan.floury@gmail.com") || !cookies[:coordinates].present?
      lat = 44.837789
      lng = -0.57918
    else
      coordinates = cookies[:coordinates].split('&')
      lat = coordinates[0]
      lng = coordinates[1]
    end

    @businesses = Business.includes(:business_category, :perks_in_time, :uses).active.for_map.with_perks_in_time.distinct.eager_load(:addresses_for_map, :main_address).merge(Address.near([lat, lng], 10))
    @geojson = {"type" => "FeatureCollection", "features" => []}

    @businesses.each do |business|
      business.addresses_for_map.each do |address|
        @geojson["features"] << {
          "type": 'Feature',
          "geometry": {
            "type": 'Point',
            "coordinates": [address.longitude, address.latitude]
          },
          "properties": {
            "marker-symbol": business.business_category.marker_symbol,
            "color": business.business_category.color,
            "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address, flash: false, lat: lat, lng: lng })
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
              "coordinates": [address.longitude, address.latitude]
            },
            "properties": {
              "marker-symbol": business.business_category.marker_symbol+"-flash",
              "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address, flash: true, lat: lat, lng: lng })
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
      format.json { render json: @geojson }
    end
  end

  def my_account
    @user = User.includes(users: :cause).find(params[:user_id])
    authorize @user
    @new_employee = User.new
    @used_perks = Use.used_by_users_for(@user)
    @liked_perks = Use.liked_by_users_for(@user)
    @employees_infos = @user.users.map do |employee|
      {id: employee.id, first_name: employee.first_name, last_name: employee.last_name, cause: employee.cause.name, likes_count: employee.liked_uses.count, uses_count: employee.used_uses.count}
    end
    @employes_sorted_by_uses = @employees_infos.sort_by { |infos| infos[:uses_count] }.reverse
    @data_for_chart = @user.users.joins(:cause).group('causes.name').count
  end

  def profile
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
    @cause = Cause.all.includes(:cause_category)
    @payments = Payment.where(user_id: current_user.id).includes(:cause)
  end

  def gift
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
  end

  def ambassador
    @businesses = Business.active.with_perks_in_time.distinct.includes(:business_category)
  end

end
