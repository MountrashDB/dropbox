class AddStatusToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :status, :string, default: "in"
  end
end
