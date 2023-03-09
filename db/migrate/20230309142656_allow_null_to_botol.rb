class AllowNullToBotol < ActiveRecord::Migration[7.0]
  def change
    change_column_null :botols, :merk_id, true
  end
end
