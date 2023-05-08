class CreateMitraBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :mitra_banks do |t|
      t.boolean :is_valid
      t.string :kodeBank
      t.string :nama
      t.string :nama_bank
      t.string :rekening
      t.references :mitra, null: false, foreign_key: true

      t.timestamps
    end
  end
end
