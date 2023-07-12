class AddBotolIdToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :botol_id, :integer
  end
end
