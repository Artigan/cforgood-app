ActiveAdmin.register BusinessCategory do
  form do |f|
    f.inputs "Identity" do
      f.input :name
    end
    f.actions
  end

permit_params :name
end