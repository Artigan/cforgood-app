ActiveAdmin.register User do
  index do
    selectable_column
    column :id
    column :email
    column :first_name
    column :last_name
    column :city
    column :created_at
    column :active
    column :admin
    column :ambassador
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :first_name
      f.input :last_name
      f.input :name
      f.input :email
      f.input :street
      f.input :zipcode
      f.input :city
      f.input :picture
      f.input :cause
      f.input :logo, :as => :file
    end
    f.inputs "Admin" do
      f.input :admin
      f.input :member
      f.input :active
      f.input :ambassador
      f.input :supervisor
      f.input :supervisor_id
      f.input :business_supervisor_id
    end
    f.actions
  end
  permit_params :first_name, :last_name, :name, :email, :street, :zipcode, :city, :picture, :admin, :member, :active, :password, :cause_id, :ambassador, :logo, :supervisor, :supervisor_id, :business_supervisor_id
end
