class RemoveMitraIdToHarga < ActiveRecord::Migration[7.0]
  def change
    remove_column :botol_hargas, :mitra_id
  end
end
