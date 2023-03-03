class AddUuIdToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :uuid, :string
  end
end
