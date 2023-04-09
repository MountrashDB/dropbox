class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.string :uuid
      t.string :nama
      t.string :nama_usaha
      t.string :handphone
      t.text :alamat_kantor
      t.string :email
      t.string :password_digest
      t.boolean :verified
      t.boolean :approved
      t.string :api_key
      t.string :api_secret
      t.timestamps
    end
  end
end
