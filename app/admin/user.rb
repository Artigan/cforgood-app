ActiveAdmin.register User do
  index do
    selectable_column
    column :id
    column :email
    column :first_name
    column :last_name
    column :city
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
      f.input :city
      f.input :picture
    end
    f.inputs "Admin" do
      f.input :admin
      f.input :active
    end
    f.actions
  end
  permit_params :first_name, :last_name, :name, :email, :city, :picture, :admin, :active
end
