class CreateMitraVas < ActiveRecord::Migration[7.0]
  def change
    create_table :mitra_vas do |t|
        t.references :mitra, null: false, foreign_key: true
        t.string :kodeBank
        t.boolean :active
        t.float :fee      
        t.string :rekening
        t.string :bank_name
        t.string :name
        t.datetime :expired
 
        t.timestamps
    end
  end
end
