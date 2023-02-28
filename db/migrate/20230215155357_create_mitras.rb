class CreateMitras < ActiveRecord::Migration[7.0]
  def change
    create_table :mitras do |t|
      t.string :uuid
      t.string :phone
      t.string :name
      t.string :contact
      t.string :address
      t.string :email      
      t.string :avatar
      t.string :password_digest
      t.integer :terms
      t.integer :status
      t.datetime :dates
      t.string :activation_code
      t.timestamps
    end
  end
end
