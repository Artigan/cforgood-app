ActiveAdmin.register User do
  index do
    selectable_column
    column :id
    column :email
    column :first_name
    column :last_name
    column :name
    column :created_at
    column :admin
    column :active
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :first_name
      f.input :last_name
      f.input :name
      f.input :email
    end
    f.inputs "Admin" do
      f.input :admin
      f.input :active
    end
    f.actions
  end
  permit_params :first_name, :last_name, :name, :email, :picture, :admin, :active
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
