class AddParamBodyToPpob < ActiveRecord::Migration[7.0]
  def change
    add_column :ppobs, :body_params, :json
  end
end
