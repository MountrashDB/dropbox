class CreateBuktiPembayarans < ActiveRecord::Migration[7.0]
  def change
    create_table :bukti_pembayarans do |t|
      t.references :mitra, null: false, foreign_key: true
      t.float :nominal
      t.string :status
      t.references :admin, null: true, foreign_key: true
      t.string :keterangan

      t.timestamps
    end
  end
end
