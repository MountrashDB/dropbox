class AddImageToBank < ActiveRecord::Migration[7.0]
  def change
    add_column :banks, :url_image, :string
  end
end
