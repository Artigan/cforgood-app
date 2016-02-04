ActiveAdmin.register Partner do
  index do
    selectable_column
    column :name
    column :email
    column :code_promo
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :email
      f.input :code_promo
    end
    f.actions
  end

permit_params :name, :email, :code_promo
end
