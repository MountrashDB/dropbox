class CreateBotolHargas < ActiveRecord::Migration[7.0]
  def change
    create_table :botol_hargas do |t|
      t.references :botol, null: false, foreign_key: true
      t.float :harga
      t.references :mitra, null: false, foreign_key: true
      t.references :box, null: false, foreign_key: true
      t.timestamps
    end
  end
end
