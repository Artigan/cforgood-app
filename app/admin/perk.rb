ActiveAdmin.register Perk do

  index do
    selectable_column
    column :perk
    column :business_id
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :perk
      f.input :business_id
      f.input :description
      f.input :detail
      f.input :periodicity_id
      f.input :times
      f.input :start_date
      f.input :end_date
      f.input :permanent
    end
    f.inputs "Admin" do
      f.input :active
    end
    f.actions
  end

  permit_params :perk, :business_id, :description, :detail, :periodicity_id, :times , :start_date, :end_date, :permanent, :active
end
