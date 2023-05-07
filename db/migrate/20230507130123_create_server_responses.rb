class CreateServerResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :server_responses do |t|
      t.text :body
      t.text :headers
      t.string :url

      t.timestamps
    end
  end
end
