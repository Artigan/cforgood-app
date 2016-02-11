ActiveAdmin.register Perk do

  index do
    selectable_column
    column :perk
    column :business
    column :created_at
    actions
  end
  form do |f|
    f.inputs "Identity" do
      f.input :perk
      f.input :business
      f.input :description
      f.input :detail
      f.input :periodicity_id
      f.input :times
      f.input :start_date
      f.input :end_date
      f.input :picture
    end
    f.inputs "Admin" do
      f.input :active
      f.input :permanent
      f.input :appel
      f.input :durable
      f.input :flash
    end
    f.actions
  end

  permit_params :perk, :business_id, :description, :detail, :periodicity_id, :times , :start_date, :end_date, :permanent, :active, :appel, :durable, :flash, :picture
end
