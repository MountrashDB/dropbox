class CreateSampahDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :sampah_details do |t|
      t.references :order_sampah, null: false, foreign_key: true
      t.references :sampah, null: false, foreign_key: true
      t.float :harga
      t.float :qty
      t.string :satuan
      t.float :sub_total

      t.timestamps
    end
  end
end
