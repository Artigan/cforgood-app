ActiveAdmin.register BusinessCategory do
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :picture, :as => :file
      f.input :marker, :as => :file
    end
    f.actions
  end

permit_params :name, :picture, :marker
end
