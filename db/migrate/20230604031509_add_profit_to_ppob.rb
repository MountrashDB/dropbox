class AddProfitToPpob < ActiveRecord::Migration[7.0]
  def up
    change_column :ppobs, :amount, :float
  end

  def down
    change_column :ppobs, :amount, :string
  end
end
