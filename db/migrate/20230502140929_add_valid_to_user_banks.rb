class AddValidToUserBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :user_banks, :is_valid, :boolean
  end
end
