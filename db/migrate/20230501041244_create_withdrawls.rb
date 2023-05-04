class CreateWithdrawls < ActiveRecord::Migration[7.0]
  def change
    create_table :withdrawls do |t|
      t.references :user, null: false, foreign_key: true
      t.references :usertransaction, null: false, foreign_key: true
      t.float :amount
      t.string :status
      t.string :kodeBank
      t.string :rekening
      t.string :nama

      t.timestamps
    end
  end
end
