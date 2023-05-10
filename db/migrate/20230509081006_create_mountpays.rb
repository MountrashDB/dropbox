class CreateMountpays < ActiveRecord::Migration[7.0]
  def change
    create_table :mountpays do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mitra, null: false, foreign_key: true
      t.float :credit
      t.float :debit
      t.float :balance
      t.string :description

      t.timestamps
    end
  end
end
