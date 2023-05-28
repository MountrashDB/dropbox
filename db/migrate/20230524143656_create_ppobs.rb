class CreatePpobs < ActiveRecord::Migration[7.0]
  def change
    create_table :ppobs do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.string :status
      t.string :amount

      t.timestamps
    end
  end
end
