class RenameVouherToVoucher < ActiveRecord::Migration[7.0]
  def change
    rename_column :jemputans, :vouhcer, :voucher
  end
end
