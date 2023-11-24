class AddGambarToJemputans < ActiveRecord::Migration[7.0]
  def change
    add_column :jemputans, :gambar, :string
  end
end
