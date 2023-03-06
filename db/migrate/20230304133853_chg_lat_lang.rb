class ChgLatLang < ActiveRecord::Migration[7.0]
  def change
    rename_column :boxes, :lat, :latitude
    rename_column :boxes, :lang, :longitude
  end
end
