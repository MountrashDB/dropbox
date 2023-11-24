class AddBeratToJemputan < ActiveRecord::Migration[7.0]
  def change
    add_column :jemputans, :berat, :float
  end
end
