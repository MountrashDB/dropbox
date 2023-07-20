class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.references :user, null: false, foreign_key: true
      t.float :amount
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
