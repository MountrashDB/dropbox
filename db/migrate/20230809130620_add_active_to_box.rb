class AddActiveToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :failed, :integer, default: 0
  end
end
