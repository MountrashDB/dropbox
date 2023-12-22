class AddUuidToOutlet < ActiveRecord::Migration[7.0]
  def change
    add_column :outlets, :uuid, :string
  end
end
