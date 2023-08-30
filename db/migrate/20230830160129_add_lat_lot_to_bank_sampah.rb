class AddLatLotToBankSampah < ActiveRecord::Migration[7.0]
  def change
    add_column :banksampahs, :latitude, :string
    add_column :banksampahs, :longitude, :string
  end
end
