module ApplicationHelper
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    if user.image # si le user est connecté avec fb
      user.image  # on affiche img de profile
    else          # sinon on utilise gravatar pr son email
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=30"
    end
  end

  #def title
    #content_for?(:title) ? content_for(:title) : DEFAULT_META['default_title']
  #end

  #def meta_description
    #content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META['meta_description']
  #end

  #def meta_image
    #content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META['meta_image']
  #end

end
