class AddPriceToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :price_pcs, :float
    add_column :boxes, :price_kg, :float
  end
end
