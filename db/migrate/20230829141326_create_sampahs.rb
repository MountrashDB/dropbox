class CreateSampahs < ActiveRecord::Migration[7.0]
  def change
    create_table :sampahs do |t|
      t.string :name
      t.string :code
      t.string :uuid
      t.references :tipe_sampah, null: false, foreign_key: true
      t.references :banksampah, null: false, foreign_key: true
      t.float :harga_kg
      t.float :harga_satuan
      t.string :description
      t.boolean :active
      t.timestamps
    end
  end
end
