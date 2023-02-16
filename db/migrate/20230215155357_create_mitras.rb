class CreateMitras < ActiveRecord::Migration[7.0]
  def change
    create_table :mitras do |t|
      t.string :uuid
      t.string :phone
      t.string :name
      t.string :contact
      t.string :address
      t.string :email      
      t.timestamps
    end
  end
end
