class AddPartnerIdToMitras < ActiveRecord::Migration[7.0]
  def change
    add_column :mitras, :partner_id, :integer
  end
end
