class CreateOutlets < ActiveRecord::Migration[7.0]
  def change
    create_table :outlets do |t|
      t.string :uuid
      t.string :name
      t.string :phone
      t.integer :otp
      t.string :mac
      t.string :email
      t.string :alamat
      t.boolean :active
      t.references :city, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true
      t.float :harga
      t.string :contact_name

      t.timestamps
    end
  end
end
