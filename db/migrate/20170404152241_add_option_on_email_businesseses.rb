class AddOptionOnEmailBusinesseses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :hidden_email, :boolean, default: false
  end
end
