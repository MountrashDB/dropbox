class ChgTipeSampahToSampahId < ActiveRecord::Migration[7.0]
  def change
    rename_column :order_details, :tipe_sampah_id, :sampah_id
  end
end
