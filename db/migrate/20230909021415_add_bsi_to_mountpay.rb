class AddBsiToMountpay < ActiveRecord::Migration[7.0]
  def change
    add_column :mountpays, :banksampah_id, :integer
  end
end
