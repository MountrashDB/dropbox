class AddHargaToTipeSampah < ActiveRecord::Migration[7.0]
  def change
    add_column :tipe_sampahs, :harga, :float
  end
end
