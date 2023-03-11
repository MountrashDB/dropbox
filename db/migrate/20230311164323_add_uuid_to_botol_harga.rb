class AddUuidToBotolHarga < ActiveRecord::Migration[7.0]
  def change
    add_column :botol_hargas, :uuid, :string
  end
end
