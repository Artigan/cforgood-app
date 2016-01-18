module ApplicationHelper
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    if user.picture # si le user est connecté avec fb
      user.picture  # on affiche img de profile
    else          # sinon on utilise gravatar pr son email
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=30"
    end
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def pro_space?
    request.env['PATH_INFO'].include?("/pro/") || request.env['PATH_INFO'].include?("/landing_business")
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
end
