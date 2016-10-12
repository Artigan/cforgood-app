ActiveAdmin.register Prospect do
 index do
    selectable_column
    column :id
    column :user
    column :name
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :user
      f.input :name
      f.input :street
      f.input :zipcode
      f.input :city
      f.input :leader_name
    end
    f.inputs "Admin" do
      f.input :canvassed
    end
    f.actions
  end

permit_params :user, :name, :street, :zipcode, :city, :leader_name, :canvassed

end
