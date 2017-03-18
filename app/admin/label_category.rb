ActiveAdmin.register LabelCategory do
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
    end
    f.actions
  end

  permit_params :name, :picture
end
