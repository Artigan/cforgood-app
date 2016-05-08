class RenamePromoToPartnerFromPartners < ActiveRecord::Migration
  def change
    rename_column :partners, :code_promo, :code_partner
  end
end
