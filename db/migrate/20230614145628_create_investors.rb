class CreateInvestors < ActiveRecord::Migration[7.0]
  def change
    create_table :investors do |t|
      t.string :status
      t.float :credit
      t.float :debit
      t.float :balance
      t.string :description
      t.timestamps
    end
  end
end
