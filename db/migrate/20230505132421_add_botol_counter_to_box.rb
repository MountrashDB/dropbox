class AddBotolCounterToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :botol_total, :integer
  end
end
