class AddFieldsToBotol < ActiveRecord::Migration[7.0]
  def change
    add_column :botols, :barcode, :string
    add_column :botols, :jenis, :integer
    add_column :botols, :product, :string
  end
end
