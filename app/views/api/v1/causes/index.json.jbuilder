json.array! @causes do |cause|
  json.extract! cause, :id, :name, :impact
  json.cause_category cause.cause_category.name
  json.picture cause.picture.url(:card)
  json.like cause.like
  json.city cause.city
end

json.array! @causes_around_me do |cause|
  json.extract! cause, :id, :name, :impact
  json.cause_category cause.cause_category.name
  json.picture cause.picture.url(:card)
  json.like cause.like
  json.city cause.city
end

json.array! @causes_national do |cause|
  json.extract! cause, :id, :name, :impact
  json.cause_category cause.cause_category.name
  json.picture cause.picture.url(:card)
  json.like cause.like
  json.city cause.city
end
