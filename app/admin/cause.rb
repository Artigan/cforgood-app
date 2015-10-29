ActiveAdmin.register Cause do
  index do
    selectable_column
    column :name
    column :cause_category
    column :impact
    column :email
    column :telephone
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :cause_category
      f.input :email
      f.input :url
      f.input :description
      f.input :street
      f.input :impact
      f.input :description_impact
      f.input :zipcode
      f.input :city
      f.input :telephone
      f.input :facebook
      f.input :twitter
      f.input :instagram
      f.input :latitude
      f.input :longitude
      f.input :picture, :as => :file
    end
    f.actions
  end

  permit_params :name, :email, :cause_category_id, :impact, :url, :latitude, :longitude, :description, :description_impact, :street, :zipcode, :city, :telephone, :facebook, :twitter, :instagram, :picture
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end