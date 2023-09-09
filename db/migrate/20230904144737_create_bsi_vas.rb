class CreateBsiVas < ActiveRecord::Migration[7.0]
  def change
    create_table :bsi_vas do |t|
      t.references :banksampah, null: false, foreign_key: true
      t.boolean :active
      t.string :bank_name
      t.datetime :expired
      t.float :fee
      t.string :kodeBank
      t.string :name
      t.string :rekening

      t.timestamps
    end
  end
end
