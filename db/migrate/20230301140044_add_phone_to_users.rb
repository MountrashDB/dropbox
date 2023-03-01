class AddPhoneToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :username, :string
    add_column :users, :active_code, :integer
  end
end
