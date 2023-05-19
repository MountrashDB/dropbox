class CreateBankLists < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :kode_bank
      t.string :name
      t.boolean :is_active

      t.timestamps
    end
  end
end
