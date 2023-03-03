class AddPasswordTokenToMitra < ActiveRecord::Migration[7.0]
  def change
    add_column :mitras, :reset_password_token, :string
    add_column :mitras, :reset_password_sent_at, :datetime
  end
end
