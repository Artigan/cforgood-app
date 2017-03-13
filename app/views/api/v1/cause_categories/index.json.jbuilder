json.array! @cause_categories do |cause_category|
  json.extract! cause_category, :id, :name, :color, :picture
end
