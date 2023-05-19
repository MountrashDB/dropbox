class AddFeeToUserVa < ActiveRecord::Migration[7.0]
  def change
    add_column :user_vas, :fee, :float
    add_column :user_vas, :active, :boolean
    add_column :user_vas, :bank_name, :string
  end
end
