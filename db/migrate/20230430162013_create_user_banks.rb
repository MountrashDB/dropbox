class CreateUserBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_banks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :kodeBank
      t.string :nama_bank
      t.string :nama
      t.string :rekening

      t.timestamps
    end
  end
end
