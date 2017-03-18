ActiveAdmin.register Label do
  index do
    selectable_column
    column :id
    column :label_category_id
    column :business_id
    column :created_at
    actions
  end

  permit_params :label_category_id, :business_id
end
