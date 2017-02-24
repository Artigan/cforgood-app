class AddSignupColumsToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :mailing, :boolean, default: true
    add_column :causes, :tax_receipt, :boolean, default: true
    add_column :causes, :followers, :string
    add_column :causes, :heard, :string
  end
end
