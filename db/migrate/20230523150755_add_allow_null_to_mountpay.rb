class AddAllowNullToMountpay < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:mountpays, :mitra_id, true)
    change_column_null(:mountpays, :user_id, true)
  end
end
