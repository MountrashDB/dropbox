class CreateKycs < ActiveRecord::Migration[7.0]
  def change
    create_table :kycs do |t|
      t.string :no_ktp
      t.string :nama
      t.string :tempat_tinggal
      t.date :tgl_lahir
      t.string :rt
      t.string :rw
      t.string :desa
      t.references :province, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true
      t.references :mitra, null: false, foreign_key: true
      t.integer :status
      t.string :agama
      t.string :pekerjaan

      t.timestamps
    end
  end
end
