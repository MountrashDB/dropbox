class CreateUsertransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :usertransactions do |t|
      t.references :user, null: false, foreign_key: true
      t.float :credit, :default => 0
      t.float :debit, :default => 0
      t.float :balance, :default => 0
      t.string :description
      t.timestamps
    end
  end
end
