class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :token, :string
    add_column :users, :refresh_token, :string
  end
end
