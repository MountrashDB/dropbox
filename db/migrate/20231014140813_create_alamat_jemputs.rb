class CreateAlamatJemputs < ActiveRecord::Migration[7.0]
  def change
    create_table :alamat_jemputs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :latitude
      t.string :longitude
      t.string :kodepos
      t.string :catatan
      t.string :alamat
      t.timestamps
    end
  end
end
