json.extract! @cause,
  :id,
  :name,
  :impact
json.picture @cause.picture.url(:card)
json.logo @cause.logo.url(:thumb)
json.extract! @cause,
  :like,
  :description,
  :link_video,
  :facebook,
  :twitter,
  :instagram,
  :telephone,
  :email,
  :url,
  :street,
  :zipcode,
  :city,
  :representative_first_name,
  :representative_last_name,
  :representative_testimonial
if current_user.cause_id == @cause.id
  json.user_cause true
else
  json.user_cause false
end
