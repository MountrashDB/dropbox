class AddUUidToKyc < ActiveRecord::Migration[7.0]
  def change
    add_column :kycs, :uuid, :string
  end
end
