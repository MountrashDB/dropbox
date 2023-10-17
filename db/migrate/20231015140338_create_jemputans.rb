class CreateJemputans < ActiveRecord::Migration[7.0]
  def change
    create_table :jemputans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :catatan
      t.references :alamat_jemput, null: false, foreign_key: true
      t.references :jam_jemput, null: false, foreign_key: true
      t.string :uuid
      t.string :phone
      t.float :sub_total
      t.float :fee
      t.float :total

      t.timestamps
    end
  end
end
