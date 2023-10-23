class CreateJemputanDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :jemputan_details do |t|
      t.references :jemputan, null: false, foreign_key: true
      t.references :tipe_sampah, null: false, foreign_key: true
      t.integer :qty
      t.float :harga
      t.float :sub_total

      t.timestamps
    end
  end
end
