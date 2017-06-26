class AddStripeIdToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :acct_id, :string
  end
end
