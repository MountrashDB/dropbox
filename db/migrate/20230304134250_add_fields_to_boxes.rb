class AddFieldsToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :nama, :string
    add_column :boxes, :jenis, :string
    add_column :boxes, :qty, :float
    add_column :boxes, :revenue, :float
    add_column :boxes, :cycles, :string
    add_column :boxes, :dates, :datetime
    add_column :boxes, :mitra_id, :integer
    add_column :boxes, :mitra_info, :string
    add_column :boxes, :admin_id, :integer
    add_column :boxes, :mitra_share, :float
    add_column :boxes, :user_share, :float
    add_column :boxes, :type_progress, :string    
  end
end
