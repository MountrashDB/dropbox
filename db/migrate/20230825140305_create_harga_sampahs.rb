class CreateHargaSampahs < ActiveRecord::Migration[7.0]
  def change
    create_table :harga_sampahs do |t|
      t.references :banksampah, null: false, foreign_key: true
      t.references :tipe_sampah, null: false, foreign_key: true
      t.float :harga_kg
      t.float :harga_satuan

      t.timestamps
    end
  end
end
