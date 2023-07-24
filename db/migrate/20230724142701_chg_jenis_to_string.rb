class ChgJenisToString < ActiveRecord::Migration[7.0]
  def change
    change_column(:botols, :jenis, :string)
  end
end
