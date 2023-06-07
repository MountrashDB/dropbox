class AddFieldsToPpob < ActiveRecord::Migration[7.0]
  def change
    add_column :ppobs, :ref_id, :string
    add_column :ppobs, :tr_id, :integer
    add_column :ppobs, :ppob_type, :string
    add_column :ppobs, :profit, :float
    add_column :ppobs, :vendor_price, :float
    add_column :ppobs, :desc, :string
  end
end
