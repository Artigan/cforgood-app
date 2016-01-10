ActiveAdmin.register Use do
  index do
    selectable_column
    column :user_id
    column :perk_id
    column :created_at
    actions
  end
end
