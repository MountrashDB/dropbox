class AllowNullWithdrawl < ActiveRecord::Migration[7.0]
  def change
    change_column_null :withdrawls, :user_id, true
    change_column_null :withdrawls, :mitra_id, true
    change_column_null :withdrawls, :usertransaction_id, true
    change_column_null :withdrawls, :mitratransaction_id, true
  end
end
