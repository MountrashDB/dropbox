class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.references :order_sampah, null: false, foreign_key: true
      t.references :tipe_sampah, null: false, foreign_key: true
      t.string :satuan
      t.float :harga
      t.float :qty
      t.float :sub_total

      t.timestamps
    end
  end
end
