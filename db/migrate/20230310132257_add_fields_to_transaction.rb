class AddFieldsToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :user_id, :integer
    add_column :transactions, :box_id, :integer
    add_column :transactions, :mitra_id, :integer
    add_column :transactions, :mitra_amount, :float
    add_column :transactions, :user_amount, :float
    add_column :transactions, :harga, :float
    add_column :transactions, :diterima, :boolean    
  end
end
