class CreateVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :vouchers do |t|
      t.references :outlet, null: false, foreign_key: true
      t.integer :code
      t.integer :days
      t.string :status
      t.date :avai_start
      t.date :avai_end

      t.timestamps
    end
  end
end
