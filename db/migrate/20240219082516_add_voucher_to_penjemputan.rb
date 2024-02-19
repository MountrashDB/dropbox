class AddVoucherToPenjemputan < ActiveRecord::Migration[7.0]
  def change
    add_column :jemputans, :vouhcer, :string
  end
end
