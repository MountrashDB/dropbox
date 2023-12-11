class AddOnlineToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :online, :boolean
    add_column :boxes, :last_online, :datetime
  end
end
