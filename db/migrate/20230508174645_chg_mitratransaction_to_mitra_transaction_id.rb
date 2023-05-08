class ChgMitratransactionToMitraTransactionId < ActiveRecord::Migration[7.0]
  def change
    rename_column :withdrawls, :mitratransaction, :mitratransaction_id
  end
end
