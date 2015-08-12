ActiveAdmin.register Business do
  index do
    selectable_column
    column :name
    column :business_category
    column :perk
    column :email
    column :telephone
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :business_category
      f.input :email
      f.input :url
      f.input :description
      f.input :perk
      f.input :detail
      f.input :street
      f.input :zipcode
      f.input :city
      f.input :telephone
      f.input :picture, :as => :file
    end
    f.actions
  end

  permit_params :name, :email, :business_category_id, :perk, :detail, :description, :url, :street, :zipcode, :city, :telephone, :picture
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