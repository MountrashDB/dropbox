class CreateOrderSampahs < ActiveRecord::Migration[7.0]
  def change
    create_table :order_sampahs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :banksampah, null: false, foreign_key: true
      t.float :sub_total
      t.float :total
      t.string :status
      t.string :uuid
      t.float :fee

      t.timestamps
    end
  end
end
