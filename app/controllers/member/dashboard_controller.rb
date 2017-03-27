class Member::DashboardController < ApplicationController

  skip_before_action :authenticate_user!, only: [:dashboard]
  before_action :get_coordinates, only: [:dashboard, :profile, :gift, :ambassador]
  before_action :find_businesses_for_search, only: [:profile, :gift, :ambassador]

  def dashboard
    # save logout access
    if !user_signed_in?
      session[:logout] = true
    end

    @businesses = Business.not_supervisor.includes(:business_category, :perks_in_time, :uses, :main_address).active.for_map.with_perks_in_time.distinct.eager_load(:addresses_for_map).merge(Address.near(@lat_lng, 10))
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
            "description": render_to_string(partial: "components/map_box", locals: { business: business, address: address, flash: false, lat_lng: @lat_lng })
          }
        }
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

  def supervisor_account
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
    @partner = Partner.find_by_code_partner(current_user.code_partner.upcase) if current_user.code_partner.present?
    @cause = current_user.cause
    @payments = Payment.where(user_id: current_user.id).includes(:cause)
  end

  def gift
  end

  def ambassador
  end

  private

  def get_coordinates
    @lat_lng = set_coordinates(params[:lat], params[:lng])
  end

  def find_businesses_for_search
    @businesses = Business.not_supervisor.includes(:business_category, :main_address).active.with_perks_in_time.distinct
  end

end
