class AddActiveToTipeSampah < ActiveRecord::Migration[7.0]
  def change
    add_column :tipe_sampahs, :active, :boolean

  end
end
