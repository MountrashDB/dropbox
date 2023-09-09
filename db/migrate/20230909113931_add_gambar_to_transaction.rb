class AddGambarToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :gambar, :string
  end
end
