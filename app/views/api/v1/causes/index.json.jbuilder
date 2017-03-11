json.array! @causes do |cause|
  json.extract! cause, :id, :name
  json.picture cause.picture.url(:card)
  json.like cause.like
  json.city cause.city
end

