class AddMitraToWithdrawl < ActiveRecord::Migration[7.0]
  def change
    add_column :withdrawls, :mitra_id, :integer
    add_column :withdrawls, :mitratransaction, :integer
  end
end
