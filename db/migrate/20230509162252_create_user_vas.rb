class CreateUserVas < ActiveRecord::Migration[7.0]
  def change
    create_table :user_vas do |t|
      t.references :user, null: false, foreign_key: true
      t.string :kodeBank
      t.string :rekening
      t.string :name
      t.datetime :expired

      t.timestamps
    end
  end
end
