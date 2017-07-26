class Pro::RegistrationsController < Devise::RegistrationsController

  def update_business
    if !request.referer.include?('/supervisor_dashboard') && session[:impersonate_id].present?
      @business = Business.find(session[:impersonate_id])
    else
      @business = current_business
    end
    if business_params[:password].present?
      @business.update(business_params)
      # sign_in(current_business, bypass: true)
    else
      @business.update_without_password(business_params)
    end
    respond_to do |format|
      format.html {redirect_to pro_business_profile_path(current_business) }
      format.js {}
    end
  end

  private

  def business_params
    params.require(:business).permit(
      :name,
      :street,
      :zipcode,
      :city,
      :url,
      :phone,
      :email,
      :password,
      :description,
      :picture,
      :business_category_id,
      :activity,
      :facebook,
      :twitter,
      :instagram,
      :leader_picture,
      :leader_first_name,
      :leader_last_name,
      :leader_description,
      :leader_phone,
      :leader_email,
      :active,
      :shop,
      :online,
      :itinerant,
      :logo,
      label_category_ids: [],
      addresses_attributes: [ :_destroy, :id, :street, :zipcode, :city,
        timetables_attributes: [ :_destroy, :id, :day, :start_at_hour, :start_at_min, :end_at_hour, :end_at_min]
      ]
    )
  end
end
