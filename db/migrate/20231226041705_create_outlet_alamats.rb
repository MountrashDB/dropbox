class CreateOutletAlamats < ActiveRecord::Migration[7.0]
  def change
    create_table :outlet_alamats do |t|
      t.references :outlet, null: false, foreign_key: true
      t.string :name
      t.string :alamat
      t.string :pic
      t.string :phone
      t.timestamps
    end
  end
end
