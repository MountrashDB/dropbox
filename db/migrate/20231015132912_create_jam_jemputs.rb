class CreateJamJemputs < ActiveRecord::Migration[7.0]
  def change
    create_table :jam_jemputs do |t|
      t.string :label
      t.integer :urut

      t.timestamps
    end
  end
end
