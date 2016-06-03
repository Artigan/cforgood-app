ActiveAdmin.register Partner do
  index do
    selectable_column
    column :id
    column :name
    column :email
    column :code_partner
    column :nb_month
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :email
      f.input :code_partner
      f.input :nb_month
    end
    f.actions
  end

permit_params :name, :email, :code_partner, :nb_month
end
