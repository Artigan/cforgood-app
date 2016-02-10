ActiveAdmin.register BusinessCategory do
  index do
    selectable_column
    column :id
    column :name
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :picture, :as => :file
      f.input :marker, :as => :file
      f.input :color
    end
    f.actions
  end

permit_params :name, :picture, :marker, :color
end
