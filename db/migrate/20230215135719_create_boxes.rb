class CreateBoxes < ActiveRecord::Migration[7.0]
  def change
    create_table :boxes do |t|
      t.string :uuid
      t.string :qr_code
      t.string :lat
      t.string :lang
      t.timestamps
    end
  end
end
