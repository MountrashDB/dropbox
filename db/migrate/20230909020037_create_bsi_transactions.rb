class CreateBsiTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bsi_transactions do |t|
      t.references :banksampah, null: false, foreign_key: true
      t.float :balance
      t.float :credit
      t.float :debit
      t.string :description

      t.timestamps
    end
  end
end
