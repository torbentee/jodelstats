class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :token
      t.datetime :expiration_date
      t.timestamps
    end
  end
end
