class RemoveMerkToBotol < ActiveRecord::Migration[7.0]
  def change
    remove_column :botols, :merk_id
  end
end
