class CreateJemputanTipeSampahs < ActiveRecord::Migration[7.0]
  def change
    create_table :jemputan_tipe_sampahs do |t|
      t.references :jemputan, null: false, foreign_key: true
      t.references :tipe_sampah, null: false, foreign_key: true

      t.timestamps
    end
  end
end
