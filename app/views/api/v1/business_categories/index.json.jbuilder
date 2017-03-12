json.array! @business_categories do |business_category|
  json.extract! business_category, :id, :name, :color, :marker_symbol, :picture
end
