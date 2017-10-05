module ApplicationHelper

  include Mobvious::Rails::Helper

  def name_user(user)
    if !current_user.last_name.blank?
      current_user.first_name.capitalize + " " + current_user.last_name.chars.first.capitalize + "."
    elsif !current_user.name.blank?
      current_user.name.split(" ")[0]
    end
  end

  def fullname_user(user)
    if !current_user.last_name.blank?
      current_user.first_name.capitalize + " " + current_user.last_name.capitalize
    elsif !current_user.name.blank?
      current_user.name
    end
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def pro_space?
    request.env['PATH_INFO'].include?("/pro/") ||
    request.env['PATH_INFO'].include?("/landing_business") ||
    (business_signed_in? && request.path == "/faq_connect")
  end

  def asso_space?
    request.env['PATH_INFO'].include?("/landing_cause")
  end

  def user_space?
    !pro_space?
  end

  def landing_page?
    request.path == "/" ||
    request.path == "/landing_business" ||
    request.path == "/landing_cause"
  end

  def signup_or_signin_page?
    request.path == "/" ||
    request.path == "/users" ||
    request.path == "/signin" ||
    request.path == "/signup" ||
    request.path == "/signup_gift" ||
    request.path == "/signup_beneficiary" ||
    request.path == "/member/signin" ||
    request.path == "/users/sign_in" ||
    request.path == "/pro" ||
    request.path == "/pro/sign_in" ||
    request.path == "/pro/sign_up"
  end

  def funnel_subscription?
    request.path ==  "/member/subscribe/new"
  end

  def pad0 items
    if items.class == Range || items.class == Array
      items.map { |item| item.to_s.rjust(2, '0') }
    else
      items.to_s.rjust(2, '0')
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end

  def display_distance distance
    if distance.round(3) > 1
      (distance).round(1).to_s + " km"
    else
      (distance * 1000).round(0).to_s + " m"
    end
  end

  def set_coordinates (lat, lng)
    if (current_user.present? && current_user.forced_geoloc)
      @lat_lng = [44.837789, -0.57918]
    elsif lat.present? && lng.present?
      @lat_lng = [lat, lng]
    elsif !cookies[:coordinates].present?
      @lat_lng = [44.837789, -0.57918]
    else
      @lat_lng = cookies[:coordinates].split('&')
    end
  end

  def navbar_classes
    classes = []
    classes << "flash" if landing_page?
    classes << "nav-user" if user_space? && user_signed_in?
    classes << "nav-business" if !user_space? && business_signed_in?

    return classes.join(' ')
  end

  def pages_controller?
    controller_name == "pages"
  end

  def devise_or_pages_controller?
    devise_controller? || controller_name == "pages"
  end

  def navbar_logo
    if devise_or_pages_controller?
      "logo_thumb_white.svg"
    else
      "logo_horizontal.svg"
    end
  end

  def navbar_logo_link
    if user_signed_in?
      member_user_dashboard_path(current_user)
    elsif business_signed_in?
      pro_business_dashboard_path(current_business)
    else
      root_path
    end
  end

  def current_impersonation
    return nil unless session[:impersonate_id].present?
    @current_impersonation ||= Business.find(session[:impersonate_id])
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  def maintenance_mode?
    ENV['MAINTENANCE_MODE'] == "ON"
  end

end
