class AddEcosystemToPartner < ActiveRecord::Migration[5.0]
  def change
    add_reference :partners, :ecosystem, index: true, foreign_key: true
  end
end
