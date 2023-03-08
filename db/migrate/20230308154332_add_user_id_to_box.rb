class AddUserIdToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :user_id, :integer
  end
end
