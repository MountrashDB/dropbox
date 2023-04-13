class AddPartnerIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :partner_id, :integer
  end
end
