class ChgPasswordDigestToEncryptedPasswordMitras < ActiveRecord::Migration[7.0]
  def change
    rename_column :mitras, :password_digest, :encrypted_password
  end
end
