ActiveAdmin.register Address do
 index do
    selectable_column
    column :id
    column :business
    column :day
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :day
      f.input :business
      f.input :street
      f.input :zipcode
      f.input :city
    end
    f.inputs "Admin" do
      f.input :active
    end
    f.actions
  end

permit_params :day, :business_id, :street, :zipcode, :city, :active

end
