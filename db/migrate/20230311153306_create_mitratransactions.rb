class CreateMitratransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :mitratransactions do |t|
      t.references :mitra, null: false, foreign_key: true
      t.float :credit, :default => 0
      t.float :debit, :default => 0
      t.float :balance, :default => 0
      t.text :description
      t.timestamps
    end
  end
end
