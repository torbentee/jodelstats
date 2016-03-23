class AddRefreshTokenToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :refresh_token, :string
    add_column :api_keys, :current_client_id, :string
    add_column :api_keys, :distinct_id, :string
  end
end
