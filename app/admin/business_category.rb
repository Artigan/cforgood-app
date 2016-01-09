ActiveAdmin.register BusinessCategory do
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :picture, :as => :file
    end
    f.actions
  end

permit_params :name, :picture
end
