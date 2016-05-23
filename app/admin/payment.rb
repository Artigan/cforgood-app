ActiveAdmin.register Payment do
  index do
    selectable_column
    column :id
    column :user_id
    column :cause_id
    column :amount_id
    column :created_at
    actions
  end
end
