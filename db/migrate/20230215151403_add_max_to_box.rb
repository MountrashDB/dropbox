class AddMaxToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :max, :integer
  end
end
