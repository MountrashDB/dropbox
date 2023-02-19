class CreateBotols < ActiveRecord::Migration[7.0]
  def change
    create_table :botols do |t|
      t.string :name
      t.string :uuid
      t.string :ukuran
      t.references :merk, null: false, foreign_key: true
      t.timestamps
    end
  end
end
