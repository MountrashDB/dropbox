class AddTanggalToJemputans < ActiveRecord::Migration[7.0]
  def change
    add_column :jemputans, :tanggal, :date
    add_column :alamat_jemputs, :phone, :string
  end
end
