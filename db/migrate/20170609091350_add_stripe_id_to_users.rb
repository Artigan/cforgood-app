class AddStripeIdToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :card_id, :mangopay_card_id
    add_column :users, :customer_id, :string
    add_column :users, :card_id, :string
    add_column :users, :shared_customer_id, :string
    add_column :users, :plan_id, :string
    add_column :users, :subscription_id, :string
  end
end
